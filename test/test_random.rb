require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoRandom < Test::Unit::TestCase
  
  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login
  end

  def test_ranking_valid
    rv = nil
    assert_nothing_raised {
      rv = @nv.random
    }

    rv.each {|v|
#      puts v.id + ':' + v.published_at.to_s + ':' + v.title
      puts v.id + ':' + v.title
#      sleep 1
    }

    sleep 1
  end

  def test_ranking_invalid
  end

  def test_ranking_notopened
  end
end
