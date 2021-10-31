require "../key"
require "../actions"
require "./rect"
require "./dom/scrollable"
require "./dom/actable"
require "./dom/checkable"
require "./dom/selectable"
require "./dom/chooseable"
require "./dom/clickable"
require "./dom/presence"

module Webdriver
  module Dom
    module Sizeable
      def bounds(force : Bool = false)
        Rect.from_size server.command.get_element_rect(locate_or_throw_error(force)).as_h
      end
    end

    module Radioable
      def selected?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end

      def select(force : Bool = false)
        click(force: force)
      end
    end
    
    module Attributable
      def attr(name, force : Bool = false)
        server.command.get_element_attribute locate_or_throw_error(force), name
      end
    end

    module Keyable
      def send_keys(*keys, force : Bool = false)
        server.command.send_keys_to_element locate_or_throw_error(force), Hash{ "text" => Keys.encode(keys) }
      end
    end

    module Inputable      
      def value(force : Bool = false)
        server.command.get_element_property(locate_or_throw_error(force), "value")
      end

      def set(*keys, force : Bool = false)
        send_keys *keys, force: force
      end
    end

    module Waitable
      def wait_until(interval : Float64 = 0.5, timeout : Int32 = 60, &block)
        Webdriver::Wait.wait_until(interval, timeout, object: self) do |element|
          yield element
        end
      end
    end
  end
end