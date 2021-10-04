module Webdriver
  module Commands
    module Alerts
      def dismiss_alert
        make_post_request("alert/dismiss")
      end

      def accept_alert
        make_post_request("alert/accept")
      end

      def get_alert_text
        make_get_request("alert/text")
      end

      def send_alert_text(text : String)
        make_post_request("alert/text", { text: text })
      end
    end
  end
end
