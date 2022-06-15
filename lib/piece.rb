require_relative "color"

class Piece
  include Color

  attr_reader :color, :directions
  attr_reader :token
  attr_reader :token_bg

  def initialize(color)
    @token = ""
    @directions = []
    @color = color
  end

  def set_token_bg(bg)
    @token_bg = colorize(@token, @color, bg)
  end

  def get_directions
    @directions
  end

end
