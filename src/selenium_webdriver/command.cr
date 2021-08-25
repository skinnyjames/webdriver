require "./capabilities"
require "./commands/session"
require "./commands/navigation"
require "./commands/window"
require "./commands/elements"

module SeleniumWebdriver
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