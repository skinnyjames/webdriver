require "../key"
require "../actions"

module Webdriver
  module Dom
    module Actable
      def act
        builder = yield Actions::ActionBuilder.new(server)
        server.command.perform_action builder
      end
    end
    
    module Checkable
      def checked?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end

      def check(force : Bool = false)
        click(force: force)
      end
    end

    module Choosable
      def selected?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end
      
      # clicks the element
      def select(force : Bool = false)
        click(force: force)
      end

      def value(force : Bool = false)
        attr("value", force: force)
      end
    end

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

    module Radioable
      def selected?(force : Bool = false) : Bool
        server.command.get_element_selected(locate_or_throw_error(force)).as_bool
      end

      def select(force : Bool = false)
        click(force: force)
      end
    end
    
    module Clickable
      def click(force : Bool = false)
        server.command.click_element locate_or_throw_error(force)
      end
    end

    module Attributable
      def attr(name, force : Bool = false)
        server.command.get_element_attribute locate_or_throw_error(force), name
      end
    end

    module Keyable
      def send_keys(*keys, force : Bool = false)
        server.command.send_keys_to_element locate_or_throw_error(force), Hash{ "text" => Keys.encode(keys) }
      end
    end

    module Inputable      
      def value(force : Bool = false)
        server.command.get_element_property(locate_or_throw_error(force), "value")
      end

      def set(*keys, force : Bool = false)
        send_keys *keys, force: force
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