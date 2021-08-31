module Webdriver
  module Commands
    module Window
      def get_window_handle
        get_value_from_response HTTP::Client.get("#{session_url}/window")
      end
  
      def get_all_window_handles
        get_value_from_response HTTP::Client.get("#{session_id}/window/handles")
      end
  
      def new_window
        get_value_from_response HTTP::Client.post("#{session_url}/window/new", body: empty_body)
      end
  
      def delete_window
        HTTP::Client.delete("#{session_url}/window")
      end
  
      def use_window(handle)
        HTTP::Client.post("#{session_url}/window", body: { handle: handle }.to_json)
      end
      
      def maximize_window
        HTTP::Client.post("#{session_url}/window/maximize", body: empty_body)
      end
  
      def minimize_window
        HTTP::Client.post("#{session_url}/window/minimize", body: empty_body)
      end

      def fullscreen_window
        HTTP::Client.post("#{session_url}/window/fullscreen", body: empty_body)
      end
  
      def get_window_rect
        get_value_from_response HTTP::Client.get("#{session_url}/window/rect")
      end  
    end
  end
end
