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
        @scanner.scan /(?<start>\^)?(?<content>.*)(?<end>\$)?/
        @start_anchor = !!@scanner["start"]? 
        @end_anchor = !!@scanner["end"]?
        @content = sanitize_content @scanner["content"]?
        self
      end
    
      def sanitize_content(content : String?)
        raise "Regex can't be nil" if content.nil?
        content.gsub(/\\s/, "")
      end
    end
  end

  class Element
    def inititalize(@context : Element | Browser, data)
    end
  end

  class ElementLocator
    def inititalize(@context : Element | Browser, **locator_tuple)
      xpath = convert_all_to_xpath(**locator_tuple)
      Element.new(@context, @context.find_element(xpath))
    end

    def convert_all_to_xpath(**locator)
      locator.each do |key, value|
      end
    end
  end
end

