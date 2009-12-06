require File.dirname(__FILE__) + '/test_helper.rb'

class TestNicovideoLogin < Test::Unit::TestCase

  def setup
  end

  def test_login_OK
    valid_account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    nv = Nicovideo.new(valid_account['mail'], valid_account['password'])

    assert_nothing_raised { nv.login }

    sleep 1
  end

  def test_login_NG
    invalid_account = {'mail' => 'invalid@account.com', 'password' => 'invalid' }
    nv = Nicovideo.new(invalid_account['mail'], invalid_account['password'])

    assert_raise(Nicovideo::LoginError) {
      nv.login
    }

    sleep 1
  end

  def test_auto_login
    valid_account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
    nv = Nicovideo.new(valid_account['mail'], valid_account['password'])

    assert_nothing_raised {
      nv.watch('sm500873') {|v|
        puts v.title
      }
    }
  end
end
