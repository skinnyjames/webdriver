module Webdriver
  struct Rect
    property :width, :height, :x, :y

    def self.from_size(size)
      x = (size["x"].as_f? || size["x"].as_i).to_i
      y = (size["y"].as_f? || size["y"].as_i).to_i
      width = (size["width"].as_f? || size["width"].as_i).to_i
      height = (size["height"].as_f? || size["height"].as_i).to_i
      new(width, height, x, y)
    end

    def initialize(@width : Int32, @height : Int32, @x : Int32, @y : Int32)
    end
  end
end