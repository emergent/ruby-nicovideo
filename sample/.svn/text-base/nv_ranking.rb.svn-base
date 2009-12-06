#!/usr/bin/ruby -Ku

require 'rubygems'
require 'nicovideo'

conf = YAML.load_file(ENV['HOME'] + '/.nicovideo/account.yml')
nv = Nicovideo.new(conf['mail'], conf['password'])

cnt = 0
nv.ranking.each do |vp|
  cnt += 1
  printf "%3d位 %-12s %s \n", cnt, vp.video_id, vp.title
end

=begin
# when using more options
nv.ranking(type='mylist', span='daily', category='all', pagenum='1').each do |vp|
  cnt += 1
  printf "%3d位 %-12s %s \n", cnt, vp.video_id, vp.title
end
=end
