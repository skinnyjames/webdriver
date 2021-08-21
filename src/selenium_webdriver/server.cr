require "http/client"
require "log"
require "json"

module SeleniumWebdriver
  abstract class Capabilities
    def self.default(browser : Symbol)
      return Chrome.new(browser_name: "chrome", browser_version: "0.0.1", platform_name: "Linux", platform_version: "something", ssl: true)
    end

    def json
    end
  end

  class Chrome < Capabilities

    @opts : NamedTuple(
      browser_name: String,
      browser_version: String,
      platform_name: String,
      platform_version: String,
      ssl: Bool
    )

    def initialize(**opts)
      @opts = opts
    end

    def to_h
      {
        browserName: @opts[:browser_name],
        browserVersion: @opts[:browser_version],
        platformName: @opts[:platform_name],
        platformVersion: @opts[:platform_version],
        acceptSslCerts: @opts[:ssl]
      }
    end
  end

  class Browser
    def initialize(@server : Server)
    end

    def goto(url : String)
      res = HTTP::Client.post("#{session_url}/url", body: { url: url }.to_json)
    end

    def session_url
      "#{@server.service_url}/session/#{@server.session_id}"
    end
  end

  class Server
    def self.start(browser = :chrome, **opts)
      new(browser, **opts).run!
    end

    @session_id : String = ""
    getter :session_id

    def initialize(browser : Symbol, *,
      @host = "127.0.0.1",
      @role = "standalone",
      @port = "4444",
      @timeout = "30",
      @background = true,
      @capabilities : Capabilities = Capabilities.default(browser)
    )
      @browser = browser
    end

    def driver_mapping
      {
        chrome: "chromedriver"
      }
    end
    
    def driver_command
      command = driver_mapping[@browser]
      raise "#{@browser} not supported" unless command
      command
    end

    def service_url
      "http://#{@host}:#{@port}"
    end

    def args 
      ["--host=#{@host}", "--port=#{@port}"]
    end

    def start_session!
      res = HTTP::Client.post("#{service_url}/session",  body: { capabilities: @capabilities.to_h }.to_json)
      Log.debug { "Response #{res.body}" }
      @session_id = JSON.parse(res.body)["value"]["sessionId"].as_s
      Log.debug { "Session #{session_id}"}
      Browser.new(self)
    end
    
    def run!
      Log.info { "Starting #{driver_command} with #{args}" }
      Process.new(driver_command, args, output: Process::Redirect::Pipe, error: Process::Redirect::Pipe)
      start_session!
    end
  end
end