require 'kconv'

module Nicovideo

  # This class doesn't access NICONICO DOUGA when an instance created.
  # At the first time you call this instance method, this accesses NICONICO
  class OpenList < Page
    include Enumerable
    
    def initialize agent, video_id, sort='c', order='d', pagenum=1
      super(agent)
      @video_id = video_id
      @pagenum  = pagenum
      @sort     = sort
      @order    = order
      @url      = url()

      params = ["mylists", "total_size", "has_next?", "has_prev?"]
      self.register_getter params
    end

    attr_reader :pagenum

    def id() @video_id end

    # call whenever pagenum changed
    def url
      @url = BASE_URL + '/openlist/' + @video_id + "?page=#{@pagenum}&sort=#{@sort}&order=#{@order}"
    end

    def each
      self.mylists.each {|ml|
        yield ml
      }
    end

    def to_a() self.mylists end

    def pagenum=(pagenum)
      if @pagenum != pagenum
        @pagenum = pagenum
        get_page(self.url, true)
      end
      @pagenum
    end

    def page=(pagenum)
      self.pagenum = pagenum
      self
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
      if page.body =~ /<strong>#{@video_id}<\/strong>を含む公開マイリストはありません。/
        @not_found = true
        raise NotFound
      end

      @total_size = page.search('//form[@name="sort"]//td[@class="TXT12"]//strong').first.inner_html.sub(/,/,'').to_i

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

      scanpattern = /<a href=\"#{BASE_URL}\/mylist\/(\d+)\">(.+?)<\/a>/ou
      listrefs = page.parser.to_html.scan(scanpattern)
      @mylists = listrefs.inject([]) {|arr, v| # v[0]: mylist id, v[1]: mylist title
        ml = MyList.new(@agent, v[0])
        ml.title = v[1]
        arr << ml
      }
    end
  end
end
