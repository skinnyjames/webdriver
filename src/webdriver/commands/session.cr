module Webdriver
  module Commands
    module Session
      def start_session(capabilities : Capabilities, @remote : Bool = false)
        res = HTTP::Client.post("#{base_url}/session",  body: { capabilities: capabilities.to_h, desiredCapabilities: capabilities.to_h }.to_json)
        body = JSON.parse(res.body)
        @session_id = @remote ? body["sessionId"].as_s : body["value"]["sessionId"].as_s
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
