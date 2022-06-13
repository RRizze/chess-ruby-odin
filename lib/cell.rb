class Cell
  attr_accessor :content
  attr_reader :position, :color

  # pos = [x, y], contnet = string
  def initialize(pos, content, color)
    @position = pos
    # content: emptry string "  " or Figure
    # content
    @content = content
    @color = color
  end

end
