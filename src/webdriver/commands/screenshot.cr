module Webdriver
  module Commands
    module Screenshot
      def capture_screenshot
        make_get_request("screenshot")
      end

      def capture_element_screenshot(element_id)
        make_get_request("element/#{element_id}/screenshot")
      end
    end
  end
end