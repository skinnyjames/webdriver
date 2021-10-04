module Webdriver
  module Alerts
    def dismiss_alert
      server.command.dismiss_alert
    end
    
    def accept_alert
      server.command.accept_alert
    end

    def alert
      server.command.get_alert_text
    end

    def alert=(text : String)
      server.command.send_alert_text(text)
    end
  end
end
