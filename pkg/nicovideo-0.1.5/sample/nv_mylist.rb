require 'rubygems'
require 'nicovideo'
require 'yaml'

mylist_ids = ARGV

# set account
account = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
mail = account['mail']
password = account['password']

# create instance
nv = Nicovideo.new(mail, password)

# login to Nicovideo (you don't need to login explicitly at v 0.0.4 or later)
nv.login

# get mylist
mylist_ids.each {|mylist_id|

  ml = nv.mylist(mylist_id)
  # method 'id' and 'mylist_id' return mylist ID(string).
  puts 'mylist id = ' + ml.id

  # method 'title', 'user' and 'description' return string.
  puts 'title = ' + ml.title
  puts 'user = ' + ml.user
  puts 'description = ' + ml.description
  
  # method 'videos' returns array of VideoPage.
  videos = ml.videos
  videos.each {|v|
    puts v.id
  }

  sleep 3
}
