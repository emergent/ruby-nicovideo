# file: mechanize-ext.rb
require 'mechanize'

module WWW
  class Mechanize
    self.class_eval {
      def post_data(url, data='', enctype=nil)
        cur_page = current_page || Page.new( nil, {'content-type'=>'text/html'})
        
        request_data = data
        
        log.debug("query: #{ request_data.inspect }") if log
        
        # fetch the page
        page = fetch_page(  :uri      => url,
                            :referer  => cur_page,
                            :verb     => :post,
                            :params   => [request_data],
                            :headers  => {
                              'Content-Length'  => request_data.size.to_s,
                            })
        add_to_history(page) 
        page
      end

      class File
        def path
          return @uri.path
        end
      end
    }
  end
end
