module Webdriver
  module Commands
    module Window
      def get_window_handle
        make_get_request("window")
      end
  
      def get_all_window_handles
        make_get_request("window/handles")
      end
  
      def new_window
        make_post_request("window/new")
      end
  
      def delete_window
        make_delete_request("window")
      end
  
      def use_window(handle)
        make_post_request("window", { handle: handle })
      end
      
      def maximize_window
        make_post_request("window/maximize")
      end
  
      def minimize_window
        make_post_request("window/minimize")
      end

      def fullscreen_window
        make_post_request("window/fullscreen")
      end
  
      def get_window_rect
        make_get_request("window/rect")
      end

      def use_frame(id)
        make_post_request("frame", { id: { Webdriver::ELEMENT_KEY => id } })
      end
    
      def use_parent_frame
        make_post_request("frame/parent")
      end
    end
  end
end
