module Webdriver
  module Commands
    module Navigation
      def visit_url(url : String) 
        res = HTTP::Client.post("#{session_url}/url", body: { url: url }.to_json)
      end
  
      def get_url
        res = HTTP::Client.get("#{session_url}/url")
        JSON.parse(res.body)["value"]
      end
  
      def go_back
        HTTP::Client.post("#{session_url}/back", body: empty_body)
      end
  
      def go_forward
        HTTP::Client.post("#{session_url}/forward", body: empty_body)
      end
  
      def refresh
        HTTP::Client.post("#{session_url}/refresh", body: empty_body)
      end
      
      def get_title
        res = HTTP::Client.get("#{session_url}/title", body: empty_body)
        JSON.parse(res.body)["value"]
      end
    end
  end
end
