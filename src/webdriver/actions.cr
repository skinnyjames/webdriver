require "uuid"
require "./key"

module Webdriver
  module Actions
  
    abstract class Action
    end

    class PauseAction < Action
      def self.pause(duration : Time::Span?)
        new("pause", duration)
      end

      getter :name

      def to_json(json : JSON::Builder)
        json.object do
          json.field "type", @name
          json.field "value", @duration.total_milliseconds.to_i
          json.field "duration", @duration.total_milliseconds.to_i
        end
      end

      def initialize(@name : String, @duration : Time::Span = 0.seconds)
      end
    end

    class KeyboardAction < Action

      def self.up(value)
        new "keyUp", value
      end

      def self.down(value)
        new "keyDown", value
      end

      getter :name, :value
      def initialize(@name : String, @value : Symbol | String)
      end
      
      def to_json(json : JSON::Builder)
        json.object do 
          json.field "type", name
          json.field "value", Keys.encode_key(value)
        end
      end
    end


    class PointerAction < Action
      def self.up(button, duration : Time::Span = 1.seconds)
        new("pointerUp", button, duration)
      end

      def self.down(button, duration : Time::Span = 1.seconds)
        new("pointerDown", button, duration)
      end

      def self.[](button)
        { 
          left: 1,
          right: 2,
          middle: 3
        }[button]
      end

      def initialize(@name : String, @button : Symbol, @duration : Time::Span = 0.seconds)
      end

      def to_json(json : JSON::Builder)
        json.object do 
          json.field "type", @name
          json.field "duration", @duration.total_milliseconds.to_i
          json.field "button", PointerAction[@button]
        end
      end
    end

    class PointerMoveAction < Action
      getter name = "pointerMove"

      def self.from_viewport(x, y, duration)
        new(x, y, duration, "viewport")
      end

      def self.from_pointer(x, y, duration)
        new(x, y, duration, "pointer")
      end

      def self.from_element(x, y, duration, element)
        new(x, y, duration, element)
      end

      def initialize(@x : Float64, @y : Float64, @duration : Time::Span, @origin : Webdriver::Element | String)
      end

      def to_json(json : JSON::Builder)
        json.object do 
          json.field "type", @name
          json.field "duration", @duration.total_milliseconds.to_i
          json.field "x", @x
          json.field "y", @y
          #json.field "origin", @origin
        end
      end
    end

    class PointerCancelAction < PointerAction
      getter name = "pointerCancel"
    end

    class ActionBuilder

      getter :key_actions, :pointer_actions

      def initialize(
        @server : Webdriver::Server, 
        @key_actions : Array(Action) = [] of Action,
        @pointer_actions : Array(Action) = [] of Action
      )
      end

      def key_press(*keys)
        @key_actions.concat 
        @key_actions.concat keys.map {|key| }
        self
      end

      def key_down(*keys)
        keys.each do |key|
          @key_actions << KeyboardAction.down(key)
          @pointer_actions << PauseAction.pause(0.seconds)
        end
        self
      end

      def key_up(*keys)
        @key_actions.concat keys.map {|key| KeyboardAction.up(key) }
        self
      end

      def right_click
        self
      end

      def pointer_down(button)
        @pointer_actions << PointerAction.down(:right)
        @key_actions << PauseAction.pause(0.seconds)
        self
      end

      def pointer_up
        @pointer_actions << PointerAction.up(:right)
        self
      end

      def pointer_move
      end

      def pointer_cancel
      end

      def scroll
      end

      def to_json(json : JSON::Builder)
        json.object do 
          json.field "actions" do 
            json.array do
              json.object do 
                json.field "type", "key"
                json.field "id", UUID.random.to_s
                json.field "actions" do 
                  json.array do 
                    @key_actions.map(&.to_json(json))
                  end
                end
              end
              json.object do 
                json.field "type", "pointer"
                json.field "id", UUID.random.to_s
                json.field "parameters" do 
                  json.object do 
                    json.field "pointerType", "mouse"
                  end
                end
                json.field "actions" do 
                  json.array do 
                    @pointer_actions.map(&.to_json(json))
                  end
                end
              end
            end
          end
        end
      end
    end

    class NullInputSource
      
      @type : String = "none"

      def pause
      end

      def to_json(json : JSON::Builder)
        json.object do 
        end
      end
    end



    class KeyInputSource < NullInputSource
      
      @type : String = "key"
      
      def initialize(*args)
        @alt = true if args.include?(:alt)
        @shift = true if args.include?(:shift)
        @ctrl = true if args.include?(:ctrl)
        @meta = true if args.include?(:meta)
      end

      def to_json(json : JSON::Builder)
        json.object do 
          json.field "pressed" do
            json.object do 
              json.field "alt", @alt
              json.field "shift", @shift
              json.field "ctrl", @ctrl
              json.field "meta", @meta
            end
          end
        end
      end
    end

    class PointerInputSource < NullInputSource
      def pointer_down
      end

      def pointer_up
      end

      def pointer_move
      end

      def pointer_cancel
      end
    end

    class WheelInputSoure < NullInputSource
      def scroll
      end
    end
  end
end