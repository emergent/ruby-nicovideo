require 'rubygems'
require 'nicovideo'
require 'yaml'

mylist_id = ARGV.shift
video_id = ARGV.shift

# set account
account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
mail = account['mail']
password = account['password']

# create instance
nv = Nicovideo.new(mail, password)

# login to Nicovideo (you don't need to login explicitly at v 0.0.4 or later)
nv.login

# get mylist
ml = nv.mylist(mylist_id)

# add video to mylist
ml.add(video_id)

# get videos with just added
videos = ml.videos
videos.each {|v|
  puts v.id
}
