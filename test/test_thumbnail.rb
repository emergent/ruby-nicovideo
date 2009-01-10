require File.dirname(__FILE__) + '/test_helper.rb'
require 'kagemusha'
require 'open-uri'

class Test_Thumbnail < Test::Unit::TestCase
  def setup
    @client = Nicovideo::Thumbnail.new
  end

  def test_get
    thumbnail = @client.get("sm2424611")
    assert("sm2424611", thumbnail["video_id"])
  end
  
  def test_get_nonexistent_video
    assert_raise(::Errno::ENOENT) {
      @client.get "sm1"
    }
  end
  
  def test_get_timeout
    Kagemusha.new(Kernel) do |m|
      m.def(:open) { sleep 30 }
      m.swap {
        assert_raise(TimeoutError) {
          @client.get("sm2424611")
        }
      }
    end
  end  
end
