module Webdriver
  module Document
    def html
      server.command.get_page_source.as_s
    end

    def execute_script(script, *args)
      server.command.execute_script(script, *args)
    end

    def pdf(**opts)
      # only works in headless mode
      server.command.print(**opts).as_s
    end
  end
end
