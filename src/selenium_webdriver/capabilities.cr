module SeleniumWebdriver
  abstract class Capabilities
    def self.default(browser : Symbol)
      return Chrome.new(browser_name: "chrome", browser_version: "0.0.1", platform_name: "Linux", platform_version: "something", ssl: true)
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
end