require "spec"
require "../src/webdriver"
require "http/server"

PORT = 8082

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

spawn same_thread: true do 
  TestServer.init "127.0.0.1", PORT
end

at_exit do
  TestServer.close
end


def with_browser(page, &block)
  browser = Webdriver::Browser.start :chrome
  browser.goto "http://localhost:#{PORT}/#{page}"
  begin
    yield browser
  ensure
    browser.quit
  end
end