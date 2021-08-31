module SeleniumWebdriver
  module Dom
    module Clickable
      def click
        server.command.click_element locate_or_throw_error
      end

      def click!
        server.command.click_element locate_or_throw_error(true)
      end
    end

    module Waitable
      def wait_until(interval : Float64 = 0.5, timeout : Int32 = 60, &block)
        SeleniumWebdriver::Wait.wait_until(interval, timeout, object: self) do |element|
          yield element
        end
      end
    end
  end
end