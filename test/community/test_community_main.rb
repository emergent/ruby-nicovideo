require File.dirname(__FILE__) + '/../test_helper.rb'

class TestNicovideoCommunityMain < Test::Unit::TestCase
  
  def setup
    account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    @nv = Nicovideo.new(account['mail'], account['password'])
    @nv.login

    @cid_valid    = 'co2389' # 公開コミュニティ
    @cid_invalid  = 'smfdsaf' # IDが間違っている
    @cid_notjoined = 'co8' # 非公開
  end

  def test_community_valid
    co = nil
    assert_nothing_raised {
      co = @nv.community(@cid_valid)
    }
    assert_instance_of(Nicovideo::Community::Main, co)
    puts co.id
    puts co.url
    puts co.title
    #puts co.description
    puts co.tags.size
    co.tags.each {|t|
      puts t
    }
    assert_equal(@cid_valid, co.id)
    assert_equal("http://ch.nicovideo.jp/community/" + @cid_valid, co.url)
    assert_instance_of(String, co.title)
    assert_instance_of(String, co.description)
    assert_instance_of(Array,  co.tags)

    sleep 5
  end

  def test_community_invalid
    co = nil
    assert_nothing_raised {
      co = @nv.community(@cid_invalid)
    }

    assert_equal(@cid_invalid,  co.id)
    assert_equal("http://ch.nicovideo.jp/community/" + @cid_invalid, co.url)

    assert_raise(Nicovideo::NotFound) { co.title }
    assert_raise(Nicovideo::NotFound) { co.description }
    assert_raise(Nicovideo::NotFound) { co.tags }

    sleep 5
  end

  def test_community_notopened
    co = nil
    assert_nothing_raised {
      co = @nv.community(@cid_notjoined)
    }

    assert_equal(@cid_notjoined,  co.id)
    assert_equal("http://ch.nicovideo.jp/community/" + @cid_notjoined, co.url)

    assert_raise(Nicovideo::Forbidden) { co.title }
    assert_raise(Nicovideo::Forbidden) { co.description }
    assert_raise(Nicovideo::Forbidden) { co.tags }

    sleep 5
  end
end
