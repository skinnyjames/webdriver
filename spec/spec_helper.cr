require "spec"
require "../src/webdriver"
require "http/server"

PORT = 8084

SERVER_URL = "http://localhost:#{PORT}"

class TestServer

  @@server : HTTP::Server?

  def self.init(host, port)
    @@server = HTTP::Server.new([
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::StaticFileHandler.new("#{File.dirname(__FILE__)}/fixture/html"),
    ])

    @@server.try do |server|
      server.bind_tcp host, port
      server.listen
    end
  end

  def self.close
    @@server.try do |server|
      server.close
    end
  end
end

puts "spawning"

spawn same_thread: true do 
  TestServer.init "127.0.0.1", PORT
end

puts "after spawn"

at_exit do
  TestServer.close
end


def with_browser(page, &block)
  if ENV["CI"]?
    browser = Webdriver::Browser.start(:chrome, remote: "http://localhost:4444", args: ["no-sandbox","headless", "disable-dev-shm-usage"])
  else
    browser = Webdriver::Browser.start(:chrome)
  end
  browser.goto "#{SERVER_URL}/#{page}"
  begin
    yield browser
  ensure
    browser.quit
  end
end