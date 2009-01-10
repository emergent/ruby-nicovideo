#!/usr/bin/ruby -Ku
require 'rubygems'
require 'nicovideo'

conf = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
nv = Nicovideo.new(conf['mail'], conf['password'])

search_word = 'Vocaloid'

nv.tagsearch( search_word ).each do |vp|
  printf "%-12s %s \n", vp.video_id, vp.title
end

# when using more options.
# tagsearch( search_word, sort=nil, order=nil, pagenum=1 )

