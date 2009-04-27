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
          open("http://ext.nicovideo.jp/api/getthumbinfo/#{video_id}", :proxy => @proxy_url) do |f|
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
			thumbnail_info = ThumbInfo.new

			parent.each_element do |element|
				if element.name == 'tags' then
          thumbnail_info.tags[element.attributes['domain']] = []
          element.each_element do |child|
            thumbnail_info.tags[element.attributes['domain']] << child.text
          end
					next
			  end
				thumbnail_info[element.name] = element.text
			end
  		thumbnail_info
		end
	end

  class ThumbInfo < Hash
    attr_accessor :tags
    def initialize
      @tags = {}
    end

    def has_tag?(tag)
      @tag_hash ||= tag_flatten.inject({}) {|tag_hash, temp_tag| tag_hash[temp_tag] = temp_tag}
      @tag_hash.has_key? tag
    end

    def tag_flatten
      @tag_flatten ||= @tags.values.flatten
    end
  end
end
