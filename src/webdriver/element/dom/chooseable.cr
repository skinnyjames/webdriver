module Webdriver
  module Dom
    module Chooseable
      def selected?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end
      
      # clicks the element
      def select(force : Bool = false)
        click(force: force)
      end

      def value(force : Bool = false)
        attr("value", force: force)
      end
    end
  end
end
