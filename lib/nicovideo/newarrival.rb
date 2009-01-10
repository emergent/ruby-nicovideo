module Nicovideo
  class Newarrival < Page
    include Enumerable

    def initialize(agent, pagenum)
      super(agent)

      @pagenum = pagenum > 10 ? 10 : pagenum

      params = ["videos"]
      self.register_getter params

      @url = url()
    end

    def parse(page)
      result_xpath = page/'//div[@class="cmn_thumb_R"]//p[@class="TXT12"]/a[@class="video"]'
      @videos = result_xpath.inject([]) do |arr, v|
        vp = VideoPage.new(@agent, v.attributes['href'].sub(/watch\/(\w+)$/,'\1'))
        vp.title = v.inner_html
        arr << vp
      end
    end

    def each
      self.videos.each {|v| yield v }
    end

    def url
      opt = '?page=' + @pagenum.to_s if @pagenum
      "#{BASE_URL}/newarrival#{opt}"
    end
  end
end
