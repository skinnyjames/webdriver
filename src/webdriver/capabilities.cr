module Webdriver
  module Capabilities
    struct Timeouts
      def initialize(*, @scripts : Int32 = 30_000, @page_load :  Int32 = 300_000, @implicit : Int32 = 0)
      end

      protected def value(json : JSON::Builder)
        json.object do 
          json.field "script", @scripts
          json.field "pageLoad", @page_load
          json.field "implicit", @implicit
        end
      end
    end

    struct Proxy

      VALID_PROXY_TYPES = ["pac", "direct", "autodetect", "system", "manual"]

      def initialize(
        @proxy_type : String,
        @proxy_autoconfig_url : String?,
        @ftp_proxy : String?,
        @http_proxy : String?,
        @no_proxy : Array(String)?,
        @ssl_proxy : String?,
        @socks_proxy : String?,
        @socks_version : Int32?
      )
        validate__args!
      end

      private def validate_args!
        validate_proxy_type!
        raise "socks_version must be between 0 and 255" if @socks_version && (@socks_version < 0 || @socks_version > 255)
      end 

      private def validate_proxy_type!
        raise "proxy_type must be in	#{VALID_PROXY_TYPES.join(",")}" unless VALID_PROXY_TYPES.include? @proxy_type
      end

      protected def value(json : JSON::Builder)
        json.object do 
          json.field "proxyType", @proxy_type
          json.field "proxyAutoconfigUrl", @proxy_autoconfig_url if @proxy_autoconfig_url
          json.field "ftpProxy", @ftp_proxy if @ftp_proxy
          json.field "httpProxy", @http_proxy if @http_proxy
          json.field "noProxy", @no_proxy if @no_proxy
          json.field "sslProxy", @ssl_proxy if @ssl_proxy
          json.field "socksProxy", @socks_proxy if @socks_proxy
          json.field "socksVersion", @socks_version if @socks_version
        end
      end
    end


    abstract class Base
      UNHANDLED_PROMPT_OPTIONS = ["dismiss", "accept", "dismiss and notify", "accept and notify", "ignore"]
      
      def self.default(browser_name, **opts)
        caps = case browser_name
        when :chrome
          Chrome.new(**opts)
        when :firefox
          Firefox.new(**opts)
        end
        raise "couldn't find caps for browser #{browser_name}" unless caps
        caps
      end

      def initialize(
        @browser_name : String,
        @options_key : String,
        *,
        @browser_version : String? = nil,
        @platform_name : String? = nil,
        @platform_version : String? = nil,
        @insecure_certs : Bool = true,
        @page_load_strategy : String? = nil,
        @proxy : Proxy? = nil,
        @windowing : Bool? = nil,
        @timeouts : Timeouts? = nil,
        @strict : Bool? = nil,
        @unhandled_prompt_behavior : String? = nil,
        @args : Array(String)? = nil
      )
      end

      protected def options_value(json : JSON::Builder)
      end

      def to_json(json : JSON::Builder)
        json.object do
          json.field "capabilities" do 
            json.object do 
              json.field "alwaysMatch" do
                json.object do 
                  json.field "browserName", @browser_name
                  json.field "browserVersion", @browser_version if @browser_version
                  json.field "platformName", @platform_name if @platform_name
                  json.field "platformVersion", @platform_version if @platform_version
                  json.field "acceptInsecureCerts", @insecure_certs if @insecure_certs
                  json.field "pageLoadStrategy", @page_load_strategy if @page_load_strategy
                  
                  if @proxy
                    json.field "proxy" do 
                      @proxy.try { |p| p.value(json) }
                    end
                  end

                  if @timeouts
                    json.field "timeouts" do 
                      @timeouts.try { |t| t.value(json) }
                    end
                  end

                  json.field "setWindowRect", @windowing if @windowing
                  json.field "strictFileInteractability", @strict if @strict
                  json.field "unhandledPromptBehavior", @unhandled_prompt_behavior if @unhandled_prompt_behavior
                  json.field "#{@options_key}" do 
                    self.options_value(json)
                  end
                end
              end
            end
          end
        end
      end
    end

    class Chrome < Base
      def initialize(
        browser_name : String = "chrome",
        options_key : String = "goog:chromeOptions",
        **args
      )
        super(browser_name, options_key, **args)
      end

      def options_value(json : JSON::Builder)
        json.object do
          json.field "args", @args if @args
        end
      end
    end

    class Firefox < Base
  
      @bin_path : String? = nil

      def initialize(
        browser_name : String = "firefox",
        options_key : String = "moz:firefoxOptions",
        **args
      )
        super(browser_name, options_key, **args)
      end

      def set_bin_path(path)
        @bin_path = path
        self
      end

      protected def options_value(json : JSON::Builder)
        json.object do 
          json.field "binary", @bin_path.to_s if @bin_path
          json.field "args", @args if @args
        end
      end
    end
  end
end
