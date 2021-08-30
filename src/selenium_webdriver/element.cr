require "./helpers/locator_helper"

module SeleniumWebdriver
  module Container
    def element(**locator)
      Dom::Element.new(self, server, **locator)
    end

    def div(**locator)
      Dom::Div.new(self, server, **locator)
    end

    def a(**locator)
      Dom::Link.new(self, server, **locator)
    end

    def text_field(**locator)
      locator = locator.merge(type: "text")
      Dom::TextField.new(self, server, **locator)
    end

    def input(**locator)
      Dom::Input.new(self, server, **locator)
    end
  end

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


  module Dom
    class Element
      include Container
      
      getter :server, :context
      
      @@node : String = "*"
      @xpath : String 
      @id : String?

      def initialize(@context : Element | Browser, @server : Server, **locator)
        @xpath = translate_locator(context, **locator)
      end

      def locate(force : Bool = false)
        ctx = context
        return @id if !@id.nil? && force
        if ctx.is_a? Browser
          @id = server.command.find_element(using: "xpath", value: @xpath).as_h.values.first.as_s
        else
          parent_id = ctx.locate_or_throw_error(force)
          @id = server.command.find_element_from_element(parent_id, using: "xpath", value: @xpath).as_h.values.first.as_s
        end
        @id
      end

      def text!
        id = locate_or_throw_error(true)
        server.command.get_element_text(id)
      end

      def text
        id = locate_or_throw_error
        server.command.get_element_text(id) 
      end

      protected def translate_locator(context : Element | Browser, **locator)
        if context.is_a? Browser
          locator.empty? ? "//#{@@node}" : "//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        else
          locator.empty? ? "//#{@@node}" : ".//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        end
      end

      protected def locate_or_throw_error(force : Bool = false) : String
        id = locate(force)
        raise "cannot locate element" if id.nil?
        id
      end
    end

    class HtmlElement < Element; include Clickable; include Waitable; end
    class Div < HtmlElement; @@node = "div"; end
    class Link < HtmlElement; @@node = "a"; end
    class TextField < HtmlElement; @@node="input"; end
    class Button < HtmlElement; @@node="Button"; end
    class Input < HtmlElement; @@node="input"; end
  end
end