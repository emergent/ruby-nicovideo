require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoMyList < Test::Unit::TestCase
  
  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login

    @mid_valid    = '3982404' # 公開マイリスト
    @mid_invalid  = 'smfdsaf' # IDが間違っている
    @mid_notopened = '3825220' # 非公開
  end

  def test_mylist_valid
    ml = nil
    assert_nothing_raised {
      ml = @nv.mylist(@mid_valid)
    }
    assert_instance_of(Nicovideo::MyList, ml)
    puts ml.id
    puts ml.url
    puts ml.title
    puts ml.description
    puts ml.videos.size
    ml.videos.each {|v| 
      puts v.id + ' ' + v.title
    }
    assert_equal(@mid_valid, ml.id)
    assert_equal("http://www.nicovideo.jp/mylist/"+@mid_valid, ml.url)
    assert_instance_of(String, ml.title)
    assert_instance_of(String, ml.description)
    assert_instance_of(Array,  ml.videos)

    ml.title = "test"
    assert_equal("test", ml.title)

    sleep 5
  end

  def test_mylist_invalid
    ml = nil
    assert_nothing_raised {
      ml = @nv.mylist(@mid_invalid)
    }

    assert_equal(@mid_invalid,  ml.id)
    assert_equal("http://www.nicovideo.jp/mylist/"+@mid_invalid, ml.url)

    assert_raise(Nicovideo::NotFound) { ml.title }
    assert_raise(Nicovideo::NotFound) { ml.description }
    assert_raise(Nicovideo::NotFound) { ml.videos }

    sleep 5
  end

  def test_mylist_notopened
    ml = nil
    assert_nothing_raised {
      ml = @nv.mylist(@mid_notopened)
    }

    assert_equal(@mid_notopened,  ml.id)
    assert_equal("http://www.nicovideo.jp/mylist/"+@mid_notopened, ml.url)

    assert_raise(Nicovideo::Forbidden) { ml.title }
    assert_raise(Nicovideo::Forbidden) { ml.description }
    assert_raise(Nicovideo::Forbidden) { ml.videos }

    sleep 5
  end
end
