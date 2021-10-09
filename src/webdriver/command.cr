require "./capabilities"
require "./commands/session"
require "./commands/navigation"
require "./commands/window"
require "./commands/elements"
require "./commands/document"
require "./commands/cookies"
require "./commands/alerts"
require "./commands/screenshot"
require "./commands/print"
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
    include Commands::Print
    
    @session_id : String?

    macro generate_error_handling(klass_map)
      {% for k, v in klass_map %}
        class {{ v }} < Exception; end
      {% end %}

      private def handle_error(body)
        if body["value"]? && body["value"].as_h? && body["value"]["error"]?
          error = body["value"]
          {% begin %}
            case error["error"]?
              {% for k, v in klass_map %}
              when {{k}} then raise {{v}}.new(error["message"].as_s)
              {% end %}
            end
          {% end %}
        end
      end
    end

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

    generate_error_handling(
    {
      "invalid selector" => InvalidSelectorException,
      "no such element" => ElementNotFoundException,
      "invalid argument" => InvalidArgumentException,
      "unexpected alert open" => UnexpectedAlertException,
      "unknown error" => UnknownException,
      "session not created" => SessionNotCreatedException,
      "stale element reference" => StaleElementReferenceException,
      "element click intercepted" => ElementClickInterceptedException,
      "element not interactable" => ElementNotInteractableException,
      "insecure certificate" => InsecureCertificateException,
      "invalid cookie domain" => InvalidCookieDomainException,
      "invalid element state" => InvalidElementStateException,
      "invalid session id" => InvalidSessionIdException,
      "javascript error" => JavascriptException,
      "move target out of bounds" => TargetOutOfBoundsException,
      "no such alert" => AlertNotFoundException,
      "no such cookie" => CookieNotFoundException,
      "no such frame" => FrameNotFoundException,
      "no such window" => WindowNotFoundException,
      "no such shadow root" => ShadowRootNotFoundException,
      "script timeout" => ScriptTimeoutException,
      "detached shadow root" => ShadowRootDetachedException,
      "timeout" => TimeoutException,
      "unable to set cookie" => UnableToSetCookieException,
      "unable to capture sreen" => UnableToCaptureScreenException,
      "unknown command" => UnknownCommandException,
      "unknown method" => UnknownMethodException,
      "unsupported operation" => UnsupportedOperationException
    })
  
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