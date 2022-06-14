require_relative "color"

class Figure
  include Color

  attr_reader :color, :directions
  attr_reader :token
  attr_reader :token_bg
  attr_accessor :has_move

  def initialize(color)
    @token = ""
    @directions = []
    @color = color
    @has_move = false
  end

  def set_token_bg(bg)
    @token_bg = colorize(@token, @color, bg)
  end

end
