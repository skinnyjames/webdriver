module Webdriver
  module Commands
    module Elements
      def find_element(using : String, value : String)
        make_post_request("element", { using: using, value: value })
      end

      def find_elements(using : String, value : String)
        make_post_request("elements", { using: using, value: value })
      end

      def find_element_from_element(element_id : String, using : String, value : String)
        make_post_request("element/#{element_id}/element", { using: using, value: value })
      end

      def find_elements_from_element(element_id : String, using : String, value : String)
        make_post_request("element/#{element_id}/elements", { using: using, value: value })
      end

      def get_active_element
        make_get_request("element/active")
      end

      def get_element_text(element_id : String)
        make_get_request("element/#{element_id}/text")
      end

      def get_element_selected(element_id : String)
        make_get_request("element/#{element_id}/selected")
      end

      def get_element_attribute(element_id : String, name : String)
        make_get_request("element/#{element_id}/attribute/#{name}")
      end

      def get_element_property(element_id : String, name : String)
        make_get_request("element/#{element_id}/property/#{name}")
      end

      def get_element_css_value(element_id : String, css_property : String)
        make_get_request("element/#{element_id}/css/#{css_property}")
      end

      def get_element_tag_name(element_id : String)
        make_get_request("element/#{element_id}/name")
      end

      def get_element_rect(element_id : String)
        make_get_request("element/#{element_id}/rect")
      end

      def get_element_enabled(element_id : String)
        make_get_request("element/#{element_id}/enabled")
      end

      def get_element_computed_label(element_id : String)
        make_get_request("element/#{element_id}/computedlabel")
      end

      def get_element_computed_role(element_id : String)
        make_get_request("element/#{element_id}/computedrole")
      end

      def clear_element(element_id : String)
        make_post_request("element/#{element_id}/clear")
      end

      def send_keys_to_element(element_id : String, body : Hash)
        make_post_request("element/#{element_id}/value", body)
      end

      def click_element(element_id : String)
        make_post_request("element/#{element_id}/click")
      end

      def is_element_displayed(element_id : String)
        make_get_request("element/#{element_id}/displayed")
      end
    end
  end
end
