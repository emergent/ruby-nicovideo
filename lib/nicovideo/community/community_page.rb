#-*- coding:utf-8 -*-
module Nicovideo::Community
  class CommunityPage < Nicovideo::Page
    COMMUNITY_BASE_URL = 'http://ch.nicovideo.jp'

    def initialize agent, community_id
      super(agent)
      @community_id = community_id
    end
  end
end
