require 'cgi'

module Nicovideo
  class Search < Page
    include Enumerable

    def initialize agent, keyword, sort=nil, order=nil, pagenum=1
      super(agent)
      @search_type = 'search'
      #@keyword = CGI.escape(CGI.escape(keyword))
      @keyword = CGI.escape(keyword)
      @sort    = sort
      @order   = order
      @pagenum = pagenum

      params = ["videos", "total_size", "has_next?", "has_prev?"]
      self.register_getter params

      @url = url()

      puts_info "url = #{@url}"
      puts_info "sort=#{@sort},order=#{@order},pagenum=#{@pagenum}"
    end

    def url
      url = "#{BASE_URL}/#{@search_type}/#{@keyword}"
      url += '?' if (@sort || @order || @pagenum)
      url += '&sort='  + @sort  if @sort
      url += '&order=' + @order if @order
      url += '&page=' + @pagenum.to_s if @pagenum
      url
    end

    def each
      self.videos.each {|v|
        yield v
      }
    end

    def to_a() self.videos end

    def pagenum=(pagenum)
      if @pagenum != pagenum
        @pagenum = pagenum
        get_page(self.url, true)
      end
      @pagenum
    end

    def page=(pagenum)
      self.pagenum = pagenum
    end

    def next
      self.pagenum = @pagenum + 1
      self
    end

    def prev
      self.pagenum = @pagenum - 1
      self
    end

    protected
    def parse(page)
      if page.body =~ /<\/strong> を含む動画はありません。/
          @not_found = true
          raise NotFound
      end

      @total_size = page.search('form[@name="sort"]//td[@class="TXT12"]//strong').first.inner_html.sub(/,/,'').to_i

      @has_next = false
      @has_prev = false
      respages = page/'//div[@class="mb16p4"]//p[@class="TXT12"]//a'
      puts_info respages.size
      respages.each {|r| puts_info r.inner_html }
      if respages.size > 0
        respages.each {|text|
          if text.inner_html =~ /前のページ/
            @has_prev = true
          end
          if text.inner_html =~ /次のページ/
            @has_next = true
          end
        }
      end

      result_xpath = page/'//div[@class="cmn_thumb_R"]//p[@class="TXT12"]/a[@class="video"]'
      
      puts_info result_xpath.size.to_s
      @videos = result_xpath.inject([]) {|arr, v|
        vp = VideoPage.new(@agent, v.attributes['href'].sub(/watch\/(\w+)$/,'\1'))
        vp.title = v.inner_html
        arr << vp
      }
    end
    
  end
end
