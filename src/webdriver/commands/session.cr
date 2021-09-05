module Webdriver
  module Commands
    module Session
      def start_session(capabilities : Capabilities)
        puts capabilities.to_h
        res = HTTP::Client.post("#{base_url}/session",  body: { capabilities: capabilities.to_h }.to_json)
        body = JSON.parse(res.body)
        puts res.body
        @session_id = body["value"]["sessionId"].as_s
        puts @session_id
        body
      end
  
      def delete_session
        HTTP::Client.delete(session_url)
      end
  
      def session_status
        res = HTTP::Client.get("#{base_url}/status")
        JSON.parse(res.body)["value"]
      end
    end
  end
end
