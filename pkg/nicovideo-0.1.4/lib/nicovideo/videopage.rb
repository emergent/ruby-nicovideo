require 'kconv'
require 'cgi'

module Nicovideo
  class VideoPage < Page
    def initialize agent, video_id
      super(agent)
      @video_id = video_id
      @params   = nil
      @url      = BASE_URL + '/watch/' + @video_id
      register_getter ["title", "tags", "published_at"]
    end

    attr_reader :video_id, :url

    def id()   @video_id end

    def type
      @params ||= get_params
      pattern = %r!^http://.*\.nicovideo\.jp/smile\?(.*?)=.*$!
      CGI.unescape(@params['url']) =~ pattern
      case $1
      when 'm'
        return 'mp4'
      when 's'
        return 'swf'
      else
        return 'flv'
      end
    end

    def comments(num=500)
      puts_info 'getting comment xml : id = ' + @video_id
      begin
        @params = get_params unless @params
        ms = @params['ms']
        raise ArgError unless ms
        
        thread_id = @params['thread_id']
        body = %!<thread res_from="-#{num}" version="20061206" thread="#{thread_id}" />!
        post_url = CGI.unescape(ms)
        comment_xml = @agent.post_data(post_url, body).body
        puts_debug comment_xml
        Comments.new(@video_id, comment_xml)
      end
    end

    def flv() return video() end

    def video()
      begin
        @params ||= get_params
        video_url = CGI.unescape(@params['url'])
        video_flv = @agent.get_file(video_url)
        video_flv
      end
    end

    def title=(title)
      @title = title
    end

    def openlist(page=1)
      OpenList.new(@agent, @video_id)
    end

    def low?
      @params ||= get_params
      return true if CGI.unescape(@params['url']) =~ /low$/
      return false
    end

    private
    def parse(page)
      # title
      @title = page.title.toutf8.sub(/#{BASE_TITLE1}$/ou, '')

      # tags
      div = page.parser.search("div#video_tags")
      @tags = div.to_html.scan(/<a href=\"tag\/[\w\%]+?\">(.+?)<\/a>/ou).inject([]) {|arr, v|
        puts_debug v[0]
        arr << v[0]
      }

      # published_at
      str = page.search("div[@id='WATCHHEADER']//p[@class='TXT12']/strong")[0].inner_text
      tm = str.scan(/\d+/)
      @published_at = Time.mktime(*tm)
    end
    
    def get_params
      raise NotFound if @not_found
      begin
        unless @params
          puts_info 'getting params : id = ' + @video_id
          @page ||= get_page(@url)
          content = @agent.get_file(BASE_URL + '/api/getflv?v=' + @video_id)
          puts_debug content
          @params = content.scan(/([^&]+)=([^&]*)/).inject({}){|h, v| h[v[0]] = v[1]; h}
        else
          puts_info 'params have already gotten : id = ' + @video_id
        end
        @params
      rescue
        @not_found = true
        raise NotFound
      end
    end
  end
end
