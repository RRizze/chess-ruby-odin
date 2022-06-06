require_relative "figure"

class Rook < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♜"
  end
end
