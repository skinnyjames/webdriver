module Webdriver
  module Document
    def execute_script(script, *args)
      server.command.execute_script(script, *args)
    end
  end
end
