module Webdriver
  module Dom
    module Clickable
      def click(force : Bool = false)
        server.command.click_element locate_or_throw_error(force)
      end
    end

    module Attributable
      def attr(name, force : Bool = false)
        server.command.get_element_attribute locate_or_throw_error(force), name
      end
    end

    module Keyable
      def send_keys(text, force : Bool = false)
        server.command.send_keys_to_element locate_or_throw_error(force), Hash{ "text" => text }
      end
    end

    module Inputable      
      def value(force : Bool = false)
        server.command.get_element_property(locate_or_throw_error(force), "value")
      end

      def set(text, force : Bool = false)
        send_keys text, force: force
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