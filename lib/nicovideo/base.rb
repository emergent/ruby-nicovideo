module Nicovideo

  class ArgError         < StandardError ; end
  class LoginError       < StandardError ; end
  class NotFound         < StandardError ; end
  class Forbidden        < StandardError ; end

  class Base

    def initialize mail=nil, password=nil, auto_login=true
      @mail = mail
      @password = password
      @agent = WWW::Mechanize.new()
      agent_init(auto_login)
      @agent.set_account(@mail, @password)

      # for parameters current video
      @vp = nil
      self
    end

    attr_reader :agent

    def agent_init auto_login=true
      @agent.instance_eval do
        alias raw_get get
        alias raw_post post
 
        def set_account(mail, password) @mail=mail; @password=password end
        def authenticated?(page)
          page.header['x-niconico-authflag'] != '0'
        end

        def login
          raise ArgError unless (@mail && @password)
          account = {'mail' => @mail, 'password' => @password }
          res = raw_post('https://secure.nicovideo.jp/secure/login?site=niconico', account)
          raise LoginError unless authenticated?(res)
        end
      end

      if auto_login
        @agent.instance_eval do
          @wait_time = 3
          def get(*args) try(:raw_get, *args) end
          def post(*args) try(:raw_post, *args) end
          
          def try(name, *args)
            page = method(name).call(*args)
            unless authenticated?(page)
              self.login
              sleep @wait_time
              page = method(name).call(*args)
              raise LoginError unless authenticated?(page)
            end
            page
          end
        end
      end
      
    end
    
    def login mail=nil, password=nil
      @mail     ||= mail
      @password ||= password
      @agent.set_account(@mail, @password)
      @agent.login
      self
    end

    def watch(video_id)
      videopage = get_videopage(video_id)
      @vp = videopage
      if block_given?
        yield videopage
      end
      videopage
    end

    def get_tags(video_id)
      get_videopage(video_id).tags
    end
    
    def get_title(video_id)
      get_videopage(video_id).title
    end
    
    def get_video(video_id)
      self.get_flv(video_id)
    end
    
    def get_flv(video_id)
      get_videopage(video_id).flv
    end
    
    def get_comments video_id, num=500
      get_videopage(video_id).comments(num)
    end

    def mylist(mylist_id)
      MyList.new(@agent, mylist_id)
    end

    def openlist(video_id)
      OpenList.new(@agent, video_id)
    end

    def random()
      Random.new(@agent)
    end

    def newarrival(pagenum=1)
      Newarrival.new(@agent,pagenum)
    end
    
    # type : 'mylist', 'view' or 'res'
    # span : 'daily', 'newarrival', 'weekly', 'monthly', 'total'
    # category : 'all', 'music' ... and more
    def ranking(type='mylist', span='daily', category='all', pagenum=nil)
      Ranking.new(@agent, type, span, category, pagenum).to_a
    end

    # keyword : search keyword
    # sort    : nil -> published date
    #           'v' -> playback times
    #           'n' -> commented date
    #           'r' -> comment number
    #           'm' -> mylist number
    def search(keyword, sort=nil, order=nil, pagenum=1)
      Search.new(@agent, keyword, sort, order, pagenum)
    end

    def tagsearch(keyword, sort=nil, order=nil, pagenum=1)
      TagSearch.new(@agent, keyword, sort, order, pagenum)
    end

    private
    def get_videopage(video_id)
      if @vp.nil? || video_id != @vp.video_id
        @vp = VideoPage.new(@agent, video_id)
      end
      @vp
    end

  end

  def Nicovideo.new(mail, password)
    Base.new(mail, password)
  end

  def Nicovideo.login(mail, password)
    Base.new(mail, password).login
  end
end
