require "./helpers/locator_helper"
require "./element/container"
require "./element/dom"
require "./document"

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
      
      getter :server, :context, :id
      
      @@node : String = "*"
      @locator_value : String
      @locator_by : String
      @context : Browser | Element
      @server : Server

      @id : String?

      def initialize(@context, @server, element_id : String? = nil, **locator)
        if locator.has_key?(:css)
          @locator_by = "css selector"
          raise "CSS Locator must have a valid value" unless locator[:css]? && locator[:css]?.try { |css| css.is_a?(String) }
          @locator_value = "#{locator[:css]?}"
        else
          @locator_by = "xpath"
          @locator_value = translate_locator(context, **locator)
        end
        @id = element_id
      end
      
      def screenshot
        server.command.capture_element_screenshot(locate_or_throw_error).as_s
      end

      protected def locate(force : Bool = false)
        ctx = context
        return @id unless @id.nil? || force
        if ctx.is_a? Browser
          @id = server.command.find_element(using: @locator_by, value: @locator_value).as_h.values.first.as_s
        else
          parent_id = ctx.locate_or_throw_error(force)
          @id = server.command.find_element_from_element(parent_id, using: @locator_by, value: @locator_value).as_h.values.first.as_s
        end
        @id
      end

      def text(force : Bool = false)
        id = locate_or_throw_error(force)
        server.command.get_element_text(id) 
      end

      protected def translate_locator(context : Element | Browser, **locator) : String
        if locator.has_key?(:xpath)
          xpath =  "#{locator[:xpath]?}"
          xpath = "(#{xpath})[#{locator[:index]?.try { |idx| idx + 1 }}]" if locator.has_key?(:index)
          return xpath
        end
        if context.is_a? Browser
          xpath = "//#{@@node}"
          xpath = "#{xpath}[#{LocatorHelper.convert_all_to_xpath(**locator)}]" if !locator.empty? && (!locator[:index]? || locator.keys.size > 1) 
        else
          xpath = ".//#{@@node}"
          xpath = "#{xpath}[#{LocatorHelper.convert_all_to_xpath(**locator)}]" if !locator.empty? && (!locator[:index]? || locator.keys.size > 1)
        end
        xpath = "(#{xpath})[#{locator[:index]?.try { |idx| idx + 1 }}]" if locator.has_key?(:index)
        xpath
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
      @locator_value : String
      @locator_by : String
      @located : Bool = false
      @ids : Array(String) = [] of String
      getter :server, :context

      def initialize(@context : Browser | Element, @server : Server, **locator)
        if locator.has_key?(:css)
          @locator_by = "css selector"
          raise "CSS Locator must have a valid value" unless locator[:css]? && locator[:css]?.try { |css| css.is_a?(String) }
          @locator_value = "#{locator[:css]?}"
        else
          @locator_by = "xpath"
          @locator_value = translate_locator(context, **locator)
        end
      end

      protected def locate(force : Bool = false)
        ctx = @context
        return @ids unless !@located || force
        if ctx.is_a? Browser
          @ids = server.command.find_elements(using: @locator_by, value: @locator_value).as_a.map do |json_hash|
            json_hash.as_h.values.first.as_s
          end
        else
          parent_id = ctx.locate_or_throw_error(force)
          @ids = server.command.find_elements_from_element(parent_id, using: @locator_by, value: @locator_value).as_a.map do |json_hash|
            json_hash.as_h.values.first.as_s
          end
        end
        @located = true
        @ids
      end

      def [](index)
        locate
        raise "No element at #{index} idx" unless @ids[index]?
        @locator_by === "css selector" ? T.new(@context, @server, @ids[index], css: @locator_value, index: index) : T.new(@context, @server, @ids[index], xpath: @locator_value, index: index)
      end

      def each
        locate.each_with_index do |id, idx|
          if @locator_by === "css selector"
            yield T.new(@context, @server, id, css: @locator_value, index: idx)
          else
            yield T.new(@context, @server, id, xpath: @locator_value, index: idx)
          end
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
      include Webdriver::Document
      include Actable
      include ElementScrollable
      include Sizeable

      def blur(force : Bool = false)
        js = <<-JS
          return (
            function blur() {
              return arguments[0].blur()
            }
          ).apply(null, arguments)
        JS
        execute_script js, { Webdriver::ELEMENT_KEY => locate_or_throw_error(force: force) }
      end
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
    register_html_element SelectList, "select", [Selectable]
    register_html_element SelectOption, "option", [Chooseable]
    register_html_element Radio, "input", [Radioable]

    register_html_element Checkbox, "input", [Checkable]
    register_html_element Input, "input"
    register_html_element Button, "button"
    register_html_element TextField, "input", [Keyable, Inputable]
    register_html_element PasswordField, "input"
  end
end