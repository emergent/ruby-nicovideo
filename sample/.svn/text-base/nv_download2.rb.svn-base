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

# get videos and comments
video_ids.each {|video_id|

  # the another way of nv_download
  puts nv.get_title(video_id)
  puts nv.get_tags(video_id).join(' ')
  puts 'getting comments xml'
  File.open("#{video_id}.xml", "wb") {|f|
    f.write nv.get_comments(video_id, 100).to_xml
  }
  puts 'getting flv file'
  File.open("#{video_id}.flv", "wb") {|f|
    f.write nv.get_flv(video_id)
  }

  sleep 1
}
