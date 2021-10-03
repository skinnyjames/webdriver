module Webdriver
  module Commands
    module Session
      def start_session(capabilities : Capabilities, remote : Bool)
        headers = HTTP::Headers{"Content-Type" => "application/json", "Connection" => "Keep-Alive", "Accept-Encoding" => "gzip" }
        json = { capabilities: capabilities.to_h(remote) }.to_json
        res = HTTP::Client.post("#{base_url}/session",  body: json, headers: headers)
        body = JSON.parse(res.body)
        @session_id = body["value"]["sessionId"].as_s
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
