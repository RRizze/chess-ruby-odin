require_relative "color"

class Figure
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

end
