require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoVideoPage < Test::Unit::TestCase

  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login

#    @vid_valid    = 'sm500873' # 閲覧可能(組曲)
    #@vid_valid    = 'sm2407057' # 閲覧可能(短い動画)
    @vid_valid    = 'sm9' # 閲覧可能(短い動画)
    @vid_invalid  = 'smfdsafd' # IDが間違っている
    @vid_notfound = 'sm500875' # 削除済み
  end

  # TODO: add test cases of openlist and mylist 
  def test_watch_ikinari
    vp = nil
    assert_nothing_raised {
      vp = @nv.watch(@vid_valid)
    }
    assert_nothing_raised { vp.flv }
    sleep 5
  end

  def test_type
    vp = @nv.watch(@vid_valid) {|vp|
      assert_instance_of(String, vp.type)
      puts vp.type
    }      
  end

  def test_watch_valid
    vp = nil
    assert_nothing_raised {
      vp = @nv.watch(@vid_valid)
    }
    assert_instance_of(Nicovideo::VideoPage, vp)
    assert_instance_of(Array,                vp.tags)
    assert_instance_of(String,               vp.title)
    assert_instance_of(Time,                 vp.published_at)
    assert_instance_of(Nicovideo::Comments,  vp.comments)
    assert_instance_of(String,               vp.csrf_token)

    puts vp.tags
    puts vp.title
    puts vp.published_at
    puts vp.csrf_token
 #   assert_nothing_raised { vp.flv }
    #assert_instance_of(String, vp.flv)
    #assert_instance_of(String, vp.video)
#    File.open("#{@vid_valid}.flv", "wb") {|f| f.write vp.flv }

    sleep 1
  end

  def test_watch_valid2
    vp = nil
    assert_nothing_raised {
      @nv.watch(@vid_valid) {|v|
        assert_instance_of(Nicovideo::VideoPage, v)
        assert_instance_of(Array,                v.tags)
        assert_instance_of(String,               v.title)
        assert_instance_of(Nicovideo::Comments,  v.comments)
        assert_instance_of(String,               v.csrf_token)
        # assert_instance_of(String, v.flv)
        # assert_instance_of(String, v.video)
      }
    }

    sleep 1
  end

  # watchは、VideoPageインスタンスを返すのみなので例外発生なし
  # VideoPageインスタンスのメソッドを実行したときに例外発生
  def test_watch_invalid
    vp = nil
    assert_nothing_raised {
      vp = @nv.watch(@vid_invalid)
    }
    assert_instance_of(Nicovideo::VideoPage, vp)
    assert_raise(Nicovideo::NotFound) { vp.tags }
    assert_raise(Nicovideo::NotFound) { vp.title }
    assert_raise(Nicovideo::NotFound) { vp.comments }
    assert_raise(Nicovideo::NotFound) { vp.flv }
    assert_raise(Nicovideo::NotFound) { vp.video }
    assert_raise(Nicovideo::NotFound) { vp.csrf_token }

    sleep 1
  end

  # watchは、VideoPageインスタンスを返すのみなので例外発生なし
  def test_watch_notfound
    vp = nil
    assert_nothing_raised {
      vp = @nv.watch(@vid_notfound)
    }
    assert_instance_of(Nicovideo::VideoPage, vp)
    assert_raise(Nicovideo::NotFound) { vp.tags }
    assert_raise(Nicovideo::NotFound) { vp.title }
    assert_raise(Nicovideo::NotFound) { vp.comments }
    assert_raise(Nicovideo::NotFound) { vp.flv }
    assert_raise(Nicovideo::NotFound) { vp.video }
    assert_raise(Nicovideo::NotFound) { vp.csrf_token }

    sleep 1
  end
end
