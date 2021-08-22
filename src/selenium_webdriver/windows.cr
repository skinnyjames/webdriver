require "./command"

module SeleniumWebdriver
  struct WindowRect
    property :width, :height, :x, :y
    def initialize(@width : Int32, @height : Int32, @x : Int32, @y : Int32)
    end
  end

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
      sizing = command.get_window_rect
      width = sizing["width"].as_i
      height = sizing["height"].as_i
      x = sizing["x"].as_i
      y = sizing["y"].as_i
      WindowRect.new(width: width, height: height, x: x, y: y)
    end

    def resize(rect : WindowRect)
      command.set_window_rect(rect)
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