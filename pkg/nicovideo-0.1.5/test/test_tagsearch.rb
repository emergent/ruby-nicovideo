require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoTagSearch < Test::Unit::TestCase
  
  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login
  end

  def test_tagsearch_testing0
    result = @nv.tagsearch("aaa")
    puts result.total_size
    result.each {|v|
      puts v.title
    }
    sleep 1
  end

  def test_tagsearch_testing1
    result = @nv.tagsearch("ミク")
    result.each {|v|
      puts v.title
    }
    sleep 1
  end

  def test_tagsearch_testing1
    result = @nv.tagsearch("ミク", 'v', 'a')
    result.each {|v|
      puts v.title
    }
    sleep 1
  end

  def test_search_testing2
    result = @nv.tagsearch("ミク", 'n')
    result.each {|v|
      puts v.title
    }
  end
  
  
=begin  
  def test_search_valid
    rv = nil
    assert_nothing_raised {
      rv = @nv.ranking
    }

    rv.each {|v|
      puts v.id + ':' + v.published_at.to_s + ':' + v.title
      sleep 1
    }

    sleep 1
  end

  def test_search_invalid
  end

  def test_search_notopened
  end
=end
end
