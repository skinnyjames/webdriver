module Webdriver
  module Commands
    module Session
      def start_session(capabilities : Capabilities::Base)
        headers = HTTP::Headers{"Content-Type" => "application/json", "Connection" => "Keep-Alive", "Accept-Encoding" => "gzip" }
        res = HTTP::Client.post("#{base_url}/session",  body: capabilities.to_json, headers: headers)
        @session_id = get_value_from_response(res)["sessionId"].as_s
      end
  
      def delete_session
        HTTP::Client.delete(session_url)
      end
  
      def session_status
        get_value_from_response HTTP::Client.get("#{base_url}/status")
      end
    end
  end
end
