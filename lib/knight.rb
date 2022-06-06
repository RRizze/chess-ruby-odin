require_relative "figure"

class Knight < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♞"
  end
end
