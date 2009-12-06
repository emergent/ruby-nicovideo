module Nicovideo
  class Ranking < Page
    def initialize agent, type='mylist', span='daily', category='all', pagenum=nil
      super(agent)
      @type     = type
      @category = category
      @pagenum  = pagenum
      @url      = url()
      self.register_getter ["videos"]
    end

    def url
      url = "#{BASE_URL}/ranking/#{@type}/#{@span}/#{@category}"
      if @pagenum
        url += '?page=' + @pagenum.to_s
      end
      url
    end

    def to_a
      videos()
    end

    protected
    def parse(page)
      ranking = page/'h3/a[@class=video]'
      @videos = ranking.inject([]) {|arr,v| #
        #puts v.attributes['href']
        vp = VideoPage.new(@agent, v.attributes['href'].sub(/#{BASE_URL}\/watch\/(\w+)$/,'\1'))
        vp.title = v.inner_html
        arr << vp
      }
    end

  end
end
