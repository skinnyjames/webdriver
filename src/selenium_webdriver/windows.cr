require "./command"

module SeleniumWebdriver
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