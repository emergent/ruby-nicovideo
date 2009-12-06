require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoSearch < Test::Unit::TestCase
  
  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login
  end

  def output_results result
    puts result.total_size
    result.each {|v|
      puts v.id + ':' + v.title
    }
  end
=begin    
  def test_search_testing0
    result = @nv.search("aaa")
    output_results result
    sleep 3
  end

  def test_search_testing1
    result = @nv.search("ミク")
    output_results result
    sleep 3
  end
=end

  def test_search_next
    result = @nv.search("ミク", 'n')
    output_results result
    i = 1
    sleep 5
    while result.has_next? && i < 5
      output_results result.next
      i += 1
      sleep 5
    end
    
    sleep 3
  end
  def test_search_prev
    result = @nv.search("ミク", 'n', nil, 5)
    output_results result
    i = 5
    sleep 5
    while result.has_prev? && i > 0
      output_results result.prev
      i -= 1
      sleep 5
    end
  end
    
=begin
  def test_search_testing2
    result = @nv.search("ミク", 'n')
    puts result.total_size
    result.each { |v|
      puts v.title
    }
    sleep 3
  end

  def test_search_testing3
    result = @nv.search("ミク", 'n', 'd')
    puts result.total_size
    result.each {|v|
      puts v.title
    }
    sleep 3
  end
=end
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
