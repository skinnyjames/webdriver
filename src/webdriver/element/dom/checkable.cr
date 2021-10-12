module Webdriver
  module Dom
    module Checkable
      def checked?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end

      def check(force : Bool = false)
        click(force: force)
      end
    end
  end
end
