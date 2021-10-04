module Webdriver
  module Commands
    module Navigation
      def visit_url(url : String) 
        make_post_request("url", { url: url })
      end
  
      def get_url
        make_get_request("url")
      end
  
      def go_back
        make_post_request("back")
      end
  
      def go_forward
        make_post_request("forward")
      end
  
      def refresh
        make_post_request("refresh")
      end
      
      def get_title
        make_get_request("title")
      end
    end
  end
end
