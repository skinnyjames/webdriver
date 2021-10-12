module Webdriver
  module Dom
    module Selectable
      def select_many(string_or_regex_arr : Array(String | Regex), *, force : Bool = false)
        string_or_regex_arr.each do |string_or_regex|
          self.select(string_or_regex, force: force)
        end
      end

      def select_many(options : Array(Dom::SelectOption), *, force : Bool = false)
        options.each do |option|
          self.select(option, force: force)
        end
      end

      def select(option : Dom::SelectOption, *, force : Bool = false)
        option.select(force: force) unless option.selected?
      end

      def select(string_or_regex : String | Regex, *, force : Bool = false)
        opt = option(visible_text: string_or_regex)
        opt.select(force: force) unless opt.selected?
      end

      def value(force : Bool = false) : String | Nil
        options.find(&.selected?(force: force)).try {|opt| opt.value.as_s }
      end
    end
  end
end
