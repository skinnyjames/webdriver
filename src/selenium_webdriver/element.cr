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
        id = locate_or_throw_error
        server.command.click_element(id)
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
        @xpath = "//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
      end

      def locate
        ctx = context
        if ctx.is_a? Browser
          @id ||= server.command.find_element(using: "xpath", value: @xpath).as_h.values.first.as_s
        else
          parent_id = ctx.locate_or_throw_error
          @id ||= server.command.find_element_from_element(parent_id, using: "xpath", value: @xpath).as_h.values.first.as_s
        end
        @id
      end

      def text
        id = locate_or_throw_error
        server.command.get_element_text(id) 
      end

      protected def locate_or_throw_error : String
        id = locate
        raise "cannot locate element" if id.nil?
        id
      end
    end

    class HtmlElement < Element; end
    class Div < HtmlElement; @@node = "div"; end
    class Link < HtmlElement; @@node = "a"; include Clickable; end
    class TextField < HtmlElement; @@node="input"; end
    class Button < HtmlElement; @@node="Button"; include Clickable; end
    class Input < HtmlElement; @@node="input"; include Clickable; end
  end
end