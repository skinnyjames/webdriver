require "./capabilities"

module SeleniumWebdriver
  struct Command
    @session_id : String | Nil

    def initialize(@base_url : String)
    end

    def start_session(capabilities : Capabilities)
      res = HTTP::Client.post("#{base_url}/session",  body: { capabilities: capabilities.to_h }.to_json)
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

    # URL commands
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

    # contexts
    def get_window_handle
      get_value_from_response HTTP::Client.get("#{session_url}/window")
    end

    def new_window
      get_value_from_response HTTP::Client.post("#{session_url}/window/new", body: empty_body)
    end

    def delete_window
      HTTP::Client.delete("#{session_url}/window")
    end

    def use_window(handle)
      HTTP::Client.post("#{session_url}/window", body: { handle: handle }.to_json)
    end

    private def get_value_from_response(res)
      JSON.parse(res.body)["value"]
    end
  
    private def empty_body
      JSON.build do |json|
        json.object do 
        end
      end
    end
    
    private def session_url
      "#{@base_url}/session/#{@session_id}"
    end

    private def base_url
      @base_url
    end
  end
end