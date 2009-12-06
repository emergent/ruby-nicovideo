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

  nv.watch(video_id) {|v|
    # method 'id' and 'video_id' return video ID(string).
    puts 'video id = ' + v.id

    # method 'title' returns string.
    puts 'title = ' + v.title

    # method 'tags' returns array of string.
    puts 'tags = ' + v.tags.join(' ')

    # method 'comments' returns instance of class Comments
    # which has methods 'to_xml', 'to_s'(same).
    puts 'getting comments xml'
    File.open("#{video_id}.xml", "wb") {|f| f.write v.comments(100).to_xml }

    # method 'flv' and 'video' return raw flv data(binary).
    puts 'getting flv file'
    File.open("#{video_id}.flv", "wb") {|f| f.write v.flv }
  }

  sleep 3
}
