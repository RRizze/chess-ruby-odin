require_relative "color"

class Piece
  include Color

  attr_reader :directions, :token, :token_bg
  attr_accessor :position, :color

  def initialize(color, position, board)
    @token = ""
    @directions = []
    @color = color
    @position = position
    @board = board
  end

  def set_token_bg(bg)
    @token_bg = colorize(@token, @color, bg)
  end

  def get_unit_vector(pos)
    x = pos[0] == 0 ? 0 : pos[0] / (pos[0]).abs
    y = pos[1] == 0 ? 0 : pos[1] / (pos[1]).abs

    return [x, y]
  end

  def get_direction(from, to)
    new_pos = [
      to[0] - from[0],
      to[1] - from[1]
    ]

    return get_unit_vector(new_pos)
  end

end
