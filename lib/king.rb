require_relative "figure"

class King < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♚"
  end
end
