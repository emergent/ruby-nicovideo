module Nicovideo
  class Random < Page
    include Enumerable

    def initialize agent
      super(agent)
      @url = url()
      self.register_getter ["videos"]
    end

    def each
      self.videos.each {|v| yield v }
    end

    def url
      "#{BASE_URL}/random"
    end

    def to_a
      videos()
    end

    def reload
    end

    protected
    def parse(page)
      result_xpath = page/'//td[@class="random_td"]//p[@class="TXT12"]/a[@class="video"]'
      @videos = result_xpath.inject([]) {|arr,v| #
        #puts v.attributes['href']
        vp = VideoPage.new(@agent, v.attributes['href'].sub(/watch\/(\w+)$/,'\1'))
        vp.title = v.inner_html
        arr << vp
      }
    end

  end
end
