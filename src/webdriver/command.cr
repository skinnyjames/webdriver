require "./capabilities"
require "./commands/session"
require "./commands/navigation"
require "./commands/window"
require "./commands/elements"
require "./commands/document"
require "./commands/cookies"
require "./commands/alerts"
require "./commands/screenshot"
require "./errors"

module Webdriver
  struct Command
    include Commands::Session
    include Commands::Navigation
    include Commands::Window
    include Commands::Elements
    include Commands::Document
    include Commands::Cookies
    include Commands::Alerts
    include Commands::Screenshot
    
    @session_id : String?

    def initialize(@base_url : String)
    end

    def set_window_rect(rect : WindowRect)
      body = { width: rect.width, height: rect.height, x: rect.x, y: rect.y }.to_json
      HTTP::Client.post("#{session_url}/window/rect", body: body)
    end

    private def get_value_from_response(res)
      Log.debug { res.body }
      body = JSON.parse(res.body)
      handle_error(body)
      body["value"]
    end

    private def make_get_request(path)
      get_value_from_response HTTP::Client.get("#{session_url}/#{path}")
    end

    private def make_delete_request(path)
      get_value_from_response HTTP::Client.delete("#{session_url}/#{path}")
    end

    private def make_post_request(path, body = nil)
      body = body ? body.to_json : empty_body
      get_value_from_response HTTP::Client.post("#{session_url}/#{path}", body: body)
    end

    private def handle_error(body)
      if body["value"]? && body["value"].as_h? && body["value"]["error"]?
        error = body["value"]
        raise InvalidSelectorException.new(error["message"].as_s) if error["error"]? == "invalid selector"
        raise ElementNotFoundException.new(error["message"].as_s) if error["error"]? == "no such element"
        raise InvalidArgumentException.new(error["message"].as_s) if error["error"]? == "invalid argument"
        raise UnexpectedAlertException.new(error["message"].as_s) if error["error"]? == "unexpected alert open"
      end
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