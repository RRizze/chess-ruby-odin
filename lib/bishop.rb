require_relative "figure"

class Bishop < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♝"
  end
end
