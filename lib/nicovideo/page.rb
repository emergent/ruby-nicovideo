require 'kconv'

module Nicovideo

  class Page
    NV_DEBUG_LEVEL = 0

    BASE_URL = 'http://www.nicovideo.jp'
    BASE_TITLE1  = '‐ニコニコ動画\(.*?\)'.toutf8
    BASE_TITLE2  = 'ニコニコ動画\(.*?\)‐'.toutf8

    def initialize agent
      @agent = agent
      @page  = nil
      @title = nil

      @not_found = false
    end
    
    public
    def exists?()
      begin
        @page = @page || get_page
        return true
      rescue
        return false
      end
    end

    def html()
      page = @page || get_page
      return nil unless page
      page.parser.to_html
    end

    def title=(title)
      @title = title
    end

    protected
    def register_getter(params)
      params.each {|p|
        p_noq = p.sub(/\?$/,'')
        eval <<-E
          @#{p_noq} = nil
          def #{p}
            if @#{p_noq}.nil?
              @page ||= get_page(@url)
            end
            @#{p_noq}
          end
        E
      }
    end
    
    def parse page
      # to be extended
    end

    def get_page url, force=false
      return @page if (@page && !force) 
      raise NotFound if @not_found

      puts_info 'getting html page : url = ' + url.to_s
      begin
        page = @agent.get(url)
        puts_debug page.header
        puts_debug page.body

        parse(page)
        @page = page
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
      rescue Exception => e
        puts_debug e.to_s
        raise e
      end
      @page
    end

    def puts_error str ; puts str if (NV_DEBUG_LEVEL >= 1) ; end
    def puts_info  str ; puts str if (NV_DEBUG_LEVEL >= 2) ; end
    def puts_debug str ; puts str if (NV_DEBUG_LEVEL >= 3) ; end
  end

end
