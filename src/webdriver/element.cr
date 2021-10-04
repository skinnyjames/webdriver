require "./helpers/locator_helper"
require "./element/container"
require "./element/dom"

module Webdriver
  module Dom
    macro register_html_element(class_name, node, mixins=[] of Dom)
      class {{ class_name }} < HtmlElement
        @@node = {{ node }}
        {% for mixin in mixins %}
          include {{ mixin }}
        {% end %}
      end

      class {{ class_name }}s < ElementCollection({{class_name}})
        @@node = {{ node }}
      end
    end

    class Element
      include Container
      
      getter :server, :context
      
      @@node : String = "*"
      @xpath : String
      @context : Browser | Element
      @server : Server

      @id : String?

      def initialize(@context, @server, element_id : String? = nil, **locator)
        @xpath = translate_locator(context, **locator)
        @id = element_id
      end
      
      def screenshot
        server.command.capture_element_screenshot(locate_or_throw_error).as_s
      end

      def locate(force : Bool = false)
        ctx = context
        return @id unless @id.nil? || force
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

      protected def translate_locator(context : Element | Browser, **locator) : String
        if locator.has_key?(:xpath)
          return "#{locator[:xpath]?}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        end
        if context.is_a? Browser
          locator.empty? ? "//#{@@node}" : "//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        else
          locator.empty? ? ".//#{@@node}" : ".//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        end
      end

      protected def locate_or_throw_error(force : Bool = false) : String
        id = locate(force)
        raise "cannot locate element" if id.nil?
        id
      end
    end


    class ElementCollection(T)
      include Container
      include Enumerable(T)

      @@node : String = "*"
      @xpath : String
      @located : Bool = false
      @ids : Array(String) = [] of String
      getter :server, :context

      def initialize(@context : Browser | Element, @server : Server, **locator)
        @xpath = translate_locator(@context, **locator)
      end

      def locate(force : Bool = false)
        ctx = @context
        return @ids unless !@located || force
        if ctx.is_a? Browser
          @ids = server.command.find_elements(using: "xpath", value: @xpath).as_a.map do |json_hash|
            json_hash.as_h.values.first.as_s
          end
        else
          parent_id = ctx.locate_or_throw_error(force)
          @ids = server.command.find_elements_from_element(parent_id, using: "xpath", value: @xpath).as_a.map do |json_hash|
            json_hash.as_h.values.first.as_s
          end
        end
        @located = true
        @ids
      end

      def each
        locate.each_with_index do |id, idx|
          yield T.new(@context, @server, id, xpath: @xpath, index: idx)
        end
      end

      protected def translate_locator(context : Element | Browser, **locator)
        if context.is_a? Browser
          locator.empty? ? "//#{@@node}" : "//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        else
          locator.empty? ? ".//#{@@node}" : ".//#{@@node}[#{LocatorHelper.convert_all_to_xpath(**locator)}]"
        end
      end
    end

    class HtmlElement < Element
      include Clickable
      include Waitable
      include Attributable
    end

    register_html_element Body, "body"
    register_html_element Header, "header"
    register_html_element Nav, "nav"
    register_html_element Ul, "ul"
    register_html_element Ol, "ol"
    register_html_element Dl, "dl"
    register_html_element Dt, "dt"
    register_html_element Dd, "dd"
    register_html_element Li, "li"
    register_html_element Section, "section"
    register_html_element P, "p"
    register_html_element H1, "h1"
    register_html_element H2, "h2"
    register_html_element H3, "h3"
    register_html_element H4, "h4"
    register_html_element H5, "h5"
    register_html_element H6, "h6"
    register_html_element Div, "div"
    register_html_element Link, "a"
    register_html_element Image, "img"
    register_html_element Article, "article"
    register_html_element Blockquote, "blockquote"
    register_html_element Pre, "pre"
    register_html_element Code, "code"
    register_html_element Footer, "footer"
    register_html_element Progress, "progress"
    register_html_element SmallTag, "small"
    register_html_element Span, "span"
    register_html_element Abbr, "abbr"
    register_html_element Figure, "figure"
    register_html_element FigureCaption, "figcaption"
    register_html_element Table, "table"
    register_html_element Caption, "caption"
    register_html_element TableHeader, "thead"
    register_html_element TableRow, "tr"
    register_html_element TableHead, "th"
    register_html_element TableFooter, "tfoot"
    register_html_element TableBody, "tbody"
    register_html_element TableDefinition, "td"
    register_html_element AddressField, "address"

    register_html_element Form, "form"
    register_html_element Fieldset, "fieldset"
    register_html_element Legend, "legend"
    register_html_element Label, "label"
    register_html_element SelectList, "select"
    register_html_element SelectOption, "option"
    register_html_element Radio, "input"

    register_html_element Input, "input"
    register_html_element Button, "button"
    register_html_element TextField, "input", [Keyable, Inputable]
    register_html_element PasswordField, "input"
  end
end