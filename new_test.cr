require "string_scanner"
module SeleniumWebdriver
  module RegexToXpath
    def self.tokenize(regex)
      Lexer.new(regex).tokenize
    end

    struct Lexer
      getter :start_anchor, :end_anchor, :content, :ignore_case

      @start_anchor : Bool? = nil
      @end_anchor : Bool? = nil
      @content : String? = nil

      def initialize(@regex : Regex, str : String = regex.source, @scanner : StringScanner = StringScanner.new(str))
        @ignore_case = @regex.options.includes?(Regex::Options::IGNORE_CASE) ? true : false
      end

      def tokenize
        @scanner.scan /(?<start>\^)?(?<content>[a-zA-Z\-0-9]*)(?<end>\$$)?/
        @start_anchor = !!@scanner["start"]? 
        @end_anchor = !!@scanner["end"]?
        @content = sanitize_content @scanner["content"]?
        self
      end
    
      def sanitize_content(content : String?)
        raise "Regex can't be nil" if content.nil?
        content.gsub(/\\s/, " ")
      end
    end
  end

  class Element
    def inititalize(@context : Element | Browser, data)
    end

    def find_element
    end
  end

  class ElementLocator
    def inititalize(@context : Element | Browser, **locator_tuple)
      xpath = convert_all_to_xpath(**locator_tuple)
      #Element.new(@context, @context.find_element(xpath))
    end

    def self.convert_all_to_xpath(**locator)
      paths = locator.map do |key, value|
        value.is_a?(Regex) ? convert_regex_to_xpath(key, value) : convert_string_to_xpath(key, value)
      end.join(" and ")
      paths
    end

    def self.convert_string_to_xpath(key, str)
      "@#{key}='#{str}'"
    end

    def self.convert_regex_to_xpath(key, regex, lexer : RegexToXpath::Lexer = RegexToXpath.tokenize(regex))
      raise "No content" unless content = lexer.content
      if lexer.start_anchor
        lexer.ignore_case ? "lower-case(@#{key})[starts-with('#{content.downcase}')]" : "@#{key}[starts-with('#{content}')]"
      elsif lexer.end_anchor
        lexer.ignore_case ? "lower-case(@#{key})[ends-with('#{content.downcase}')]" : "@#{key}[ends-with('#{content}')]"
      else
        lexer.ignore_case ? "lower-case(@#{key})[contains('#{content.downcase}')]" : "@#{key}[contains('#{content}')]"
      end
    end
  end
end

puts SeleniumWebdriver::ElementLocator.convert_all_to_xpath(id: /hello/i, class: "world")
