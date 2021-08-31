module Webdriver
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
          Log.info { exception }
          raise exception
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

      def get_element_selected(element_id : String)
        get_value_from_response HTP::Client.get("#{session_url}/element/#{element_id}/selected")
      end

      def get_element_attribute(element_id : String, name : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/attribute/#{name}")
      end

      def get_element_property(element_id : String, name : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/property/#{name}")
      end

      def get_element_css_value(element_id : String, css_property : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/css/#{css_property}")
      end

      def get_element_tag_name(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/name")
      end

      def get_element_rect(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/rect")
      end

      def get_element_enabled(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/enabled")
      end

      def get_element_computed_label(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/computedlabel")
      end

      def get_element_computed_role(element_id : String)
        get_value_from_response HTTP::Client.get("#{session_url}/element/#{element_id}/computedrole")
      end

      def clear_element(element_id : String)
        HTTP::Client.post("#{session_url}/element/#{element_id}/clear", body: empty_body)
      end

      def send_keys_to_element(element_id : String, body : Hash)
        get_value_from_response HTTP::Client.post("#{session_url}/element/#{element_id}/value", body: body.to_json)
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
