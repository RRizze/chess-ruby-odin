class Cell
  attr_accessor :content
  attr_accessor :position
  attr_reader :color

  # pos = [x, y], contnet = string
  def initialize(pos, content, color)
    @position = pos
    @content = content
    @color = color
  end

end
