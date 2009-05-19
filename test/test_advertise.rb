require File.dirname(__FILE__) + '/test_helper.rb'
require 'kagemusha'
require 'open-uri'

class Test_Advertise < Test::Unit::TestCase
  def setup
  end

  def test_get
    tag_info = Nicovideo::Advertise.tag_info("平沢進")
    puts tag_info
    assert_instance_of(Hash, tag_info)
  end
  
  def test_get_timeout
    Kagemusha.new(Kernel) do |m|
      m.def(:open) { sleep 30 }
      m.swap {
        assert_raise(TimeoutError) {
          Nicovideo::Advertise.tag_info("平沢進")
        }
      }
    end
  end  
end
