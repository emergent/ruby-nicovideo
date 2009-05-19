require 'open-uri'
require 'cgi'

module Nicovideo
  class Advertise  < Page
    def initialize agent, video_id = nil
      super(agent)
      @video_id = video_id
    end

    def self.tag_info tag, wait_sec = 10, retry_max = 0
			retry_count = 0
      begin
        result = timeout(wait_sec) do
          open("http://uad-api.nicovideo.jp/sub/1.0/UadKeywordService/getProbabilityStatusQuery?idvideo=sm16&keyword=#{CGI.escape(tag)}") do |f|
            f.read
          end
        end

        item = {}
        result.split(/&/).each do |param|
          pair = /(.*)=(.*)/.match(param).to_a.values_at(1, 2)
          item[pair[0]] = pair[1].to_i
        end

        item
      rescue TimeoutError => e
        raise e if retry_count >= retry_max
        retry_count += 1
        retry
      end
    end
  end
end
