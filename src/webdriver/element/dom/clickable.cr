module Webdriver
  module Dom
    module Clickable
      def click(*keys, force : Bool = false)
        act &.key_down(*keys) if keys.size > 0
        server.command.click_element locate_or_throw_error(force)
        act &.key_up(*keys) if keys.size > 0
      end

      def dblclick(*keys, force : Bool = false)
        act do |builder|
          builder.key_down(*keys)
          builder.move_to_element locate_or_throw_error(force)
          builder.pointer_down(:left)
          builder.pointer_up(:left)
          builder.pointer_down(:left)
          builder.pointer_up(:left)
          builder.key_up(*keys)
        end
      end
    end
  end
end