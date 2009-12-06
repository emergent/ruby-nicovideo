require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoOpenList < Test::Unit::TestCase

  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login

    @vid_valid    = 'sm500873' # 公開マイリストが存在（単一ページ）
    @vid_valid2   = 'sm500873' # 公開マイリストが存在（複数ページ）
    @vid_invalid  = 'smfdsafd' # IDがおかしい（動画が存在しない）
    @vid_notfound = 'sm500875' # 公開マイリストが存在しない
  end

  def test_openlist_testing
    result = @nv.openlist("sm500873")
    result.each {|v|
      puts v.title
    }
  end

  def test_openlist_valid
    ol = nil
    assert_nothing_raised {
      ol = @nv.openlist(@vid_valid)
    }
    assert_instance_of(Nicovideo::OpenList, ol)
    assert_instance_of(Array,               ol.mylists)
    assert_instance_of(Array,               ol.to_a)
    assert_instance_of(Fixnum,              ol.total_size)
    assert_instance_of(Fixnum,              ol.pagenum)
    assert(ol.has_next?)
    assert(!ol.has_prev?)

    assert_nothing_raised {
      ol.pagenum = 2
    }

    assert_equal(ol.pagenum, 2)
    assert(ol.has_next?)
    assert(ol.has_prev?)

    assert_nothing_raised {
      ol.next
    }

    assert_equal(ol.pagenum, 3)

    sleep 1
  end

  def test_openlist_valid2
    ol = nil

    assert_nothing_raised {
      @nv.watch(@vid_valid) {|v|
        ol = v.openlist
      }
    }
      
    assert_instance_of(Nicovideo::OpenList, ol)
    assert_instance_of(Array,               ol.mylists)
    assert_instance_of(Array,               ol.to_a)
    assert_instance_of(Fixnum,              ol.total_size)
    assert_instance_of(Fixnum,              ol.pagenum)
    assert(ol.has_next?)
    assert(!ol.has_prev?)

    sleep 1
  end

  def test_openlist_invalid
    ol = nil
    assert_nothing_raised {
      ol = @nv.openlist(@vid_invalid)
    }

    assert_instance_of(Nicovideo::OpenList, ol)
    assert_raise(Nicovideo::NotFound) { ol.mylists }
    assert_raise(Nicovideo::NotFound) { ol.to_a }
    assert_raise(Nicovideo::NotFound) { ol.total_size }
    assert_raise(Nicovideo::NotFound) { ol.has_next? }
    assert_raise(Nicovideo::NotFound) { ol.has_prev? }
    assert_raise(Nicovideo::NotFound) { ol.next }
    assert_raise(Nicovideo::NotFound) { ol.prev }

    sleep 1
  end

  def test_openlist_notfound
    ol = nil
    assert_nothing_raised {
      ol = @nv.openlist(@vid_notfound)
    }

    assert_instance_of(Nicovideo::OpenList, ol)
    assert_raise(Nicovideo::NotFound) { ol.mylists }
    assert_raise(Nicovideo::NotFound) { ol.to_a }
    assert_raise(Nicovideo::NotFound) { ol.total_size }
    assert_raise(Nicovideo::NotFound) { ol.has_next? }
    assert_raise(Nicovideo::NotFound) { ol.has_prev? }
    assert_raise(Nicovideo::NotFound) { ol.next }
    assert_raise(Nicovideo::NotFound) { ol.prev }

    sleep 1
  end
end
