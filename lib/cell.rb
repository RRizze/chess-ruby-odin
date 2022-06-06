class Cell
  attr_accessor :content

  # pos = [x, y], contnet = string
  def initialize(pos, content)
    @pos = pos
    @content = content
  end

  def set_position(new_pos)
    @pos = new_pos
  end

  def get_position
    @pos
  end
end
