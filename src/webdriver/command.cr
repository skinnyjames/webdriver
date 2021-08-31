require "./capabilities"
require "./commands/session"
require "./commands/navigation"
require "./commands/window"
require "./commands/elements"
require "./errors"

module Webdriver
  struct Command
    include Commands::Session
    include Commands::Navigation
    include Commands::Window
    include Commands::Elements
    
    @session_id : String?

    def initialize(@base_url : String)
    end

    def set_window_rect(rect : WindowRect)
      body = { width: rect.width, height: rect.height, x: rect.x, y: rect.y }.to_json
      HTTP::Client.post("#{session_url}/window/rect", body: body)
    end


    private def get_value_from_response(res)
      body = JSON.parse(res.body)
      handle_error(body)
      body["value"]
    end

    private def handle_error(body)
      if body["value"]? && body["value"].as_h? && body["value"]["error"]?
        error = body["value"]
        raise InvalidSelectorException.new(error["message"].as_s) if error["error"]? == "invalid selector"
        raise ElementNotFoundException.new(error["message"].as_s) if error["error"]? == "no such element"
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