require "uuid"
require "./key"
require "./element"

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

    # Mouse pointer action
    class PointerAction < Action
      # Mouse up
      # :nodoc:
      def self.up(button : Symbol, duration : Time::Span = 0.seconds)
        new("pointerUp", button, duration)
      end

      # Mouse down
      # :nodoc:
      def self.down(button : Symbol, duration : Time::Span = 0.seconds)
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

    struct Origin
      def initialize(@type : String, @id : String? = nil)
      end

      def to_json(json : JSON::Builder)
        if @type === "element"
          json.object do
            json.field Webdriver::ELEMENT_KEY, @id
          end
        else
          json.string @type
        end
      end
    end

    class WheelAction < Action

      getter name = "scroll"

      def self.from_viewport(x, y, delta_x : Int32 = 0, delta_y : Int32 = 0, duration : Time::Span=0.seconds)
        new(x, y, Origin.new("viewport"), delta_x: delta_x, delta_y: delta_y, duration: duration)
      end

      def self.from_element(x, y, id, delta_x : Int32 = 0, delta_y : Int32 = 0, duration : Time::Span=0.seconds)
        new(x, y, Origin.new("element", id), delta_x: delta_x, delta_y: delta_y, duration: duration)
      end

      def initialize(@x : Int32, @y : Int32, @origin : Origin, @delta_x : Int32, @delta_y : Int32, @duration : Time::Span=0.seconds)
      end

      def to_json(json : JSON::Builder)
        json.object do
          json.field "type", name
          json.field "x", @x
          json.field "y", @y
          json.field "deltaX", @delta_x
          json.field "deltaY", @delta_y
          json.field "duration", @duration.total_milliseconds.to_i
          json.field "origin" do
            @origin.to_json(json)
          end
        end
      end
    end

    class PointerMoveAction < Action
      getter name = "pointerMove"

      def self.from_viewport(x, y, duration)
        new(x, y, duration, Origin.new("viewport"))
      end

      def self.from_pointer(x, y, duration)
        new(x, y, duration, Origin.new("pointer"))
      end

      def self.from_element(x, y, duration, element)
        new(x, y, duration, Origin.new("element", element))
      end

      def initialize(@x : Int32, @y : Int32, @duration : Time::Span, @origin : Origin)
      end

      def to_json(json : JSON::Builder)
        json.object do
          json.field "type", @name
          json.field "duration", @duration.total_milliseconds.to_i
          json.field "x", @x
          json.field "y", @y
          json.field "origin" do
            @origin.to_json(json)
          end
        end
      end
    end

    class ActionBuilder

      getter :key_actions, :pointer_actions

      def initialize(
        @server : Webdriver::Server,
        @key_actions : Array(Action) = [] of Action,
        @pointer_actions : Array(Action) = [] of Action,
        @wheel_actions : Array(Action) = [] of Action
      )
      end

      def key_press(*keys)
        @key_actions.concat
        @key_actions.concat keys.map {|key| }
        self
      end

      def pause(duration : Time::Span = 0.seconds)
        @key_actions << PauseAction.pause(duration)
        @pointer_actions << PauseAction.pause(duration)
        @wheel_actions << PauseAction.pause(duration)
        self
      end

      def key_down(*keys)
        keys.each do |key|
          @key_actions << KeyboardAction.down(key)
          @pointer_actions << PauseAction.pause(0.seconds)
          @wheel_actions << PauseAction.pause(0.seconds)
        end
        self
      end

      def key_up(*keys)
        keys.each do |key|
          @key_actions << KeyboardAction.up(key)
          @pointer_actions << PauseAction.pause(0.seconds)
          @wheel_actions << PauseAction.pause(0.seconds)
        end
        self
      end

      def pointer_down(button)
        @pointer_actions << PointerAction.down(button)
        @key_actions << PauseAction.pause(0.seconds)
        @wheel_actions << PauseAction.pause(0.seconds)
        self
      end

      def pointer_up(button)
        @pointer_actions << PointerAction.up(button)
        @key_actions << PauseAction.pause(0.seconds)
        @wheel_actions << PauseAction.pause(0.seconds)
        self
      end

      def move_to_element(element)
        @pointer_actions << PointerMoveAction.from_element(0, 0, 0.seconds, element)
        @key_actions << PauseAction.pause(0.seconds)
        @wheel_actions << PauseAction.pause(0.seconds)
        self
      end

      def pointer_move(x, y, from="pointer")
        if from === "pointer"
          @pointer_actions << PointerMoveAction.from_pointer(x, y, 0.seconds)
        else
          @pointer_actions << PointerMoveAction.from_viewport(x, y, 0.seconds)
        end
        @key_actions << PauseAction.pause(0.seconds)
        @wheel_actions << PauseAction.pause(0.seconds)
        self
      end

      def scroll(x, y, delta_x : Int32 = 0, delta_y : Int32 = 0, duration : Time::Span = 0.seconds, element : Bool =  false, id : String? = nil)
        if !!element && !id.nil?
          @wheel_actions << WheelAction.from_element(x, y, id, delta_x: delta_x, delta_y: delta_y, duration: duration)
        else
          @wheel_actions << WheelAction.from_viewport(x, y,  delta_x: delta_x, delta_y: delta_y, duration: duration)
        end
        @key_actions << PauseAction.pause(0.seconds)
        @pointer_actions << PauseAction.pause(0.seconds)
        self
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
                json.field "type", "wheel"
                json.field "id", UUID.random.to_s
                json.field "actions" do
                  json.array do
                    @wheel_actions.map(&.to_json(json))
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
  end
end