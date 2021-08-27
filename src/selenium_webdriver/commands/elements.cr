module SeleniumWebdriver
  module Commands
    module Elements
      begin
        def find_element(using : String, value : String)
          get_value_from_response HTTP::Client.post("#{session_url}/element", body: { using: using, value: value}.to_json)
        rescue exception
          Log.info { exception }
          raise exception
        end
      end

      def find_elements(using : String, value : String)
        begin
          get_value_from_response HTTP::Client.post("#{session_url}/elements", body: { using: using, value: value }.to_json)
        rescue exception
          puts exception
        end
      end

      def find_element_from_element(element_id : String, using : String, value : String)
        begin
          get_value_from_response HTTP::Client.post("#{session_url}/element/#{element_id}/element", body: { using: using, value: value }.to_json)
        rescue exception
          Log.info { exception }
          raise exception
        end
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
        begin
          HTTP::Client.post("#{session_url}/element/#{element_id}/click", body: empty_body)
        rescue ex
          raise ex
        end
      end
    end
  end
end
