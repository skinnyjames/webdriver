module Webdriver
  abstract class Capabilities
    def self.default(browser : Symbol, args : Array(String) = [] of String)
      return Chrome.new(browser_name: "chrome", browser_version: "93.0", platform_name: "Linux", platform_version: "", ssl: true, args: args)
    end

    def to_h
    end
  end

  class Chrome < Capabilities

    @opts : NamedTuple(
      browser_name: String,
      browser_version: String,
      platform_name: String,
      platform_version: String,
      ssl: Bool,
      args: Array(String)
    )

    def initialize(**opts)
      @opts = opts
    end

    def args
      @opts[:args]
    end

    def to_h(remote)
      if remote 
        Hash(String, Hash(String, String | Hash(String, Array(String)))){
          "alwaysMatch" => { 
            "browserName" => @opts[:browser_name],
            "goog:chromeOptions" => { 
              "args" => @opts[:args]
            } 
          }
        }
      else
        Hash(String, String | Array(String) | Bool){
          "browserName" => @opts[:browser_name],
          "browserVersion" => @opts[:browser_version],
          "platformName" => @opts[:platform_name],
          "platformVersion" => @opts[:platform_version],
          "acceptSslCerts" => @opts[:ssl],
        }
      end
    end
  end
end