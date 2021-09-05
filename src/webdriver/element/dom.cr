module Webdriver
  module Dom
    module Clickable
      def click
        server.command.click_element locate_or_throw_error
      end

      def click!
        server.command.click_element locate_or_throw_error(true)
      end
    end

    module Attributable
      def attr(name)
        server.command.get_element_attribute locate_or_throw_error, name
      end
    end

    module Keyable
      def send_keys(*keys)
        server.command.send_keys_to_element locate_or_throw_error, Hash{ "text" => keys.join("") }
      end
    end

    module Inputable      
      def value
        val = server.command.get_element_property(locate_or_throw_error, "value")
        Array(String).from_json(val.as_s).join("")
      end

      def set(text)
        send_keys text.split("")
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