require "http/client"
require "log"
require "json"
require "./command"
require "./windows"

module SeleniumWebdriver
  module Navigation
    def goto(url : String)
      server.command.visit_url(url)
    end

    def url
      server.command.get_url
    end

    def back
      server.command.go_back
    end

    def title
      server.command.get_title
    end

    def forward
      server.command.go_forward
    end

    def refresh
      server.command.refresh
    end
  end

  class Browser
    include Navigation
    getter :server, windows

    def initialize(@server : Server)
      window_handle = current_window_handle
      @windows = Windows.new([Window.new(window_handle)], command: server.command)
    end

    def use(window : Window)
      server.command.use_window(window.handle)
    end

    def close(window : Window)
      use(window)
      server.command.delete_window
      window_index = windows.index(window)
      windows.remove(window)
      if window_index
        switch_to = windows.find_closest_index(window_index)
        switch_to.nil? ? quit : use(windows[switch_to])
      end
    end

    def quit
      server.command.delete_session
    end

    private def current_window_handle
      server.command.get_window_handle.as_s
    end
  end

  class Server
    def self.start(browser = :chrome, **opts)
      new(browser, **opts).run!
    end

    @@process : Process?

    getter :command

    def initialize(browser : Symbol, *,
      @host = "127.0.0.1",
      @role = "standalone",
      @port = "4444",
      @timeout = "30",
      @background = true,
      @capabilities : Capabilities = Capabilities.default(browser)
    )
      @browser = browser
      @command = Command.new(service_url)
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

    def ready?
      command.session_status["ready"]
    end
    
    def run!
      Log.info { "Starting #{driver_command} with #{args}" }
      @@process ||= Process.new(driver_command, args, output: Process::Redirect::Pipe, error: Process::Redirect::Pipe)
      start_session!
    end

    def start_session!
      @command.start_session(@capabilities)
      Browser.new(self)
    end
  end
end