module Webdriver
  module Commands
    module Session
      def start_session(capabilities : Capabilities)
        res = HTTP::Client.post("#{base_url}/session",  body: { capabilities: capabilities.to_h, desired_capabilities: capabilities.to_h }.to_json)
        puts res.body
        body = JSON.parse(res.body)
        @session_id = body["value"]["sessionId"].as_s
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
