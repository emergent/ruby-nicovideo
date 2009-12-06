require 'cgi'

module Nicovideo
  class TagSearch < Search

    def initialize agent, keyword, sort=nil, order=nil, pagenum=1
      super(agent, keyword, sort, order, pagenum)
      @search_type = 'tag'
      @url = url()
    end

  end
end
