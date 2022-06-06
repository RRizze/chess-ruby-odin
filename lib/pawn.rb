require_relative "figure"

class Pawn < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♟"
  end

end
