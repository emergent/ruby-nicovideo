require 'kconv'


require 'rss/2.0'
require 'rss/1.0'
require 'json'

module Nicovideo
  class MyList < Page
    NICO_MYLIST = 'マイリスト'

    def initialize agent, mylist_id
      super(agent)
      @mylist_id = mylist_id
      @raw_url = BASE_URL + '/mylist/' + @mylist_id
      @url     = BASE_URL + '/mylist/' + @mylist_id + '?rss=2.0'

      params = ["title", "user", "description", "videos", "rss"]
      self.register_getter params
    end
    
    attr_reader :myliset_id

    def id()  @mylist_id end
    def url() @raw_url   end

    def add(video_id)
      video_page = VideoPage.new @agent, video_id

      begin
        add_result = @agent.post(video_page.url, {
            :mylist => "add",
            :mylistgroup_name => "",
            :csrf_token => video_page.csrf_token,
            :group_id => @mylist_id,
            :ajax => "1"})

        result_code = JSON.parse(add_result.body.sub(/^\(?(.*?)\)?$/, '\1'))

        if result_code["result"] == "success" then
          # added video isn't applied to rss immediately, so add video into list by hand.
          page = @page || get_page(@url)
          @videos << video_page
          return self
        end
        raise ArgError if result_code["result"] == "duperror"
        raise StandardError
      rescue WWW::Mechanize::ResponseCodeError => e
        rc = e.response_code
        puts_info rc
        if rc == "404" || rc == "410"
          @not_found = true
          raise NotFound
        elsif rc == "403"
          raise Forbidden
        else
          raise e
        end
      end
    end

    private
    def parse(page)
      @rss = RSS::Parser.parse(page.body)
      @title = rss.channel.title.sub(/#{BASE_TITLE2+NICO_MYLIST} /, '')
      @user  = rss.channel.managingEditor
      @description = rss.channel.description

      @videos = rss.items.collect {|i|
        vp = VideoPage.new(@agent, i.link.sub(/^.*watch\/(\w+)$/, '\1'))
        vp.title = i.title
        vp
      }

    end
  end
end
