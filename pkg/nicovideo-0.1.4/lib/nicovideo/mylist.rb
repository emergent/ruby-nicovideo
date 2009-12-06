require 'kconv'


require 'rss/2.0'
require 'rss/1.0'

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
