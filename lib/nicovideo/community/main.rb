require 'uri'

module Nicovideo::Community
  class Main < CommunityPage
    def initialize agent, community_id
      super(agent, community_id)

      @url = COMMUNITY_BASE_URL + '/community/' + @community_id
      register_getter ["title", "tags", "founded_at", "owner", "level"]
    end

    private
    def parse(page)
      # title
      @title = page.title.toutf8.sub(/ - [^-]+$/ou, '')

      # tags
      div = page.parser.search("//div[@class='community_bg']").first.to_html
      puts_debug div
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
    end
  end
end
