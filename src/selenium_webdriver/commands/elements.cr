module SeleniumWebdriver
  module Commands
    module Elements
      def find_element(using : String, value : String)
        get_value_from_response HTTP::Client.post("#{session_url}/element", body: { using: using, value: value}.to_json)
      end

      def find_elements(using : String, value : String)
        get_value_from_response HTTP::Client.post("#{session_url}/elements", body: { using: using, value: value }.to_json)
      end

      def find_element_from_element(element_id : String, using : String, value : String)
        get_value_from_response HTTP::Client.post("#{session_url}/element/#{element_id}/element", body: { using: using, value: value }.to_json)
      end

      def find_elements_from_element(element_id : String, using : String, value : String)
        get_value_from_response HTTP::Client.post("#{session_url}/element/#{element_id}/elements", body: { using: using, value: value }.to_json)
      end

      def get_active_element
        get_value_from_response HTTP::Client.get("#{session_url}/element/active")
      end

      def get_element_text(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/text")
      end

      def click_element(element_id : String)
        HTTP::Client.post("#{session_url}/element/#{element_id}/click", body: empty_body)
      end
    end
  end
end
