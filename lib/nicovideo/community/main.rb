require 'uri'

module Nicovideo::Community
  class Main < CommunityPage
    def initialize agent, community_id
      super(agent, community_id)

      @url = COMMUNITY_BASE_URL + '/community/' + @community_id
      register_getter ["title", "description", "tags", "founded_at", "owner", "level"]
    end

    attr_reader :community_id, :url
    def id()   @community_id end

    def add_video(video_id, visibility = 1)
      result = @agent.post(COMMUNITY_BASE_URL + "/edit_video", :mode => "upload", :community_id => @community_id, 
                            :video_id => video_id, :public => visibility)

      error_description = result.search("//p[@class='TXT12 error_description']")
      return if error_description.empty?

      raise Nicovideo::Forbidden.new(error_description.inner_html)
    end

    private
    def parse(page)
      raise Nicovideo::NotFound if @not_found
      begin
        # title
        @title = page.title.toutf8.sub(/ - [^-]+$/ou, '')

        # description
        div = page.parser.search("//div[@class='community_bg']").first
        puts_debug div
        @description = div.search("//div[@class='community_description']").first.inner_html
        div = div.to_html

        # tags
        @tags = div.scan(/<a href=\"\/search\/([^?]+)\?mode=t\"/ou).inject([]) {|arr, v|
          puts_debug v[0]
          arr << URI.unescape(v[0])
        }

        # founded_at
        founded_time = div.match(/開設日：<strong>(\d+)年(\d+)月(\d+)日/).to_a.values_at(1, 2, 3)
        @founded_at = Time.local(founded_time[0], founded_time[1], founded_time[2])

        # owner
        @owner = div.match(/オーナー：.*?<strong>([^<]+)<\/strong>/).to_a[1]

        # level
        @level = div.match(/レベル：.*?<strong>([^<]+)<\/strong>/m).to_a[1].to_i
      rescue
        @not_found = true
        raise Nicovideo::NotFound
      end
    end
  end
end
