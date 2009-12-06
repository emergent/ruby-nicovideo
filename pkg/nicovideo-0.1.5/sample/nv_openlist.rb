require 'rubygems'
require 'nicovideo'
require 'yaml'

video_ids = ARGV

# set account
account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
mail = account['mail']
password = account['password']

# create instance
nv = Nicovideo.new(mail, password)

# login to Nicovideo (you don't need to login explicitly at v 0.0.4 or later)
nv.login

# get openlist
video_ids.each {|video_id|

  ol = nv.openlist(video_id)
  # method 'id' and 'video_id' return video ID(string).
  puts 'video id = ' + ol.id

  # method 'total_size' returns Fixnum.
  puts 'total_size = ' + ol.total_size.to_s
  
  # method 'mylists' returns array of MyList.
  begin
    mls = ol.mylists
    mls.each {|ml| puts ml.id + ':' + ml.title }
    sleep 1
  end while (ol.has_next? && ol.next)
  
}
