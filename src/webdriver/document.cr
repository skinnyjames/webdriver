module Webdriver
  module Document
    def html
      server.command.get_page_source
    end

    def execute_script(script, *args)
      server.command.execute_script(script, *args)
    end

    def print(**opts)
      # only works in headless mode
      server.command.print(**opts).as_s
    end
  end
end
