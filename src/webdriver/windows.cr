require "./command"
require "./element/rect"

module Webdriver
  struct Window
    getter :handle, :type
    def initialize(@handle : String, @type : Symbol = :tab)
    end
  end

  class Windows
    getter :command

    include Enumerable(Window)

    def initialize(@collection : Array(Window), @command : Command)
    end

    def new
      payload = command.new_window
      type = payload["type"].as_s === "tab" ? :tab : :window
      handle = payload["handle"].as_s
      window = Window.new(handle, type)
      @collection << window
      window
    end

    def size
      sizing = command.get_window_rect.as_h
      Rect.from_size(sizing)
    end

    def resize(rect : Rect)
      command.set_window_rect(rect)
    end 

    def resize(*, width : Int32?, height : Int32?, x : Int32?, y : Int32?)
      rect = size
      rect.width = width if width
      rect.height = height if height
      rect.x = x if x
      rect.y = y if y
      resize(rect)
    end

    def remove(window : Window)
      @collection.delete(window)
    end

    protected def find_closest_index(index)
      return nil if @collection.empty?
      return index unless !(@collection.size > index)
      return index - 1
    end

    def [](index : Int)
      @collection[index]
    end

    def each
      @collection.each do |window|
        yield window
      end
    end
  end
end