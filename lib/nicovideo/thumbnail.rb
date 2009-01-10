require 'open-uri'
require 'timeout'
require 'rexml/document'

module Nicovideo
	class Thumbnail
    def initialize(proxy_url = nil)
      @proxy_url =  proxy_url
    end
		
		def get(video_id, wait_sec = 10, retry_max = 2)
			root = get_response(video_id, wait_sec, retry_max)
			
			get_elements(root.elements["thumb"])
		end

		def get_response(video_id, wait_sec, retry_max)
			retry_count = 0
      begin
        body = timeout(wait_sec) do
          open("http://www.nicovideo.jp/api/getthumbinfo/#{video_id}", :proxy => @proxy_url) do |f|
            f.read
          end
        end

        root = REXML::Document.new(body).root
        raise ::Errno::ENOENT::new(video_id) unless root.attributes.get_attribute('status').value == 'ok'
        root
      rescue TimeoutError => e
        raise e if retry_count >= retry_max
        retry_count += 1
        retry
      end
		end
		
		def get_elements(parent)
			thumbnail_info = {}

			parent.each_element do |element|
				if element.has_elements? then
					thumbnail_info[element.name] = element.texts # doesn't support recursive xml.
					next
			  end
				thumbnail_info[element.name] = element.text
			end
  		thumbnail_info
		end
	end
end
