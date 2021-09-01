require "string_scanner"
module Webdriver
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
    
      def sanitize_content(content : String?) : String
        raise "Regex can't be nil" if content.nil?
        content.gsub(/\\s/, " ")
      end
    end
  end

  class LocatorHelper
    def self.convert_all_to_xpath(**locator) : String
      paths = locator.map do |key, value|
        if key == :xpath
          nil
        elsif key == :index && value.is_a? Int32
          convert_index_to_xpath(key, value)
        else
          value.is_a?(Regex) ? convert_regex_to_xpath(key, value) : convert_string_to_xpath(key, value)
        end
      end.reject(&.nil?).join(" and ")
      paths
    end

    def self.convert_string_to_xpath(key, str) : String
      "@#{key}='#{str}'"
    end

    def self.convert_index_to_xpath(key, index : Int) : String
      "position()=#{index + 1}"
    end

    def self.convert_regex_to_xpath(key, regex, lexer : RegexToXpath::Lexer = RegexToXpath.tokenize(regex)) : String
      raise "No content" unless content = lexer.content
      if lexer.start_anchor
        lexer.ignore_case ? "@#{key}[starts-with(normalize-space(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')), '#{content.downcase}')]" : "@#{key}[starts-with(normalize-space(.),'#{content}')]"
      elsif lexer.end_anchor
        lexer.ignore_case ? "@#{key})[ends-with(normalize-space(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')), '#{content.downcase}')]" : "@#{key}[ends-with(normalize-space(.),'#{content}')]"
      else
        lexer.ignore_case ? "contains(translate(@#{key},'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'), '#{content.downcase}')" : "contains(@#{key}, '#{content}')"
      end
    end
  end
end