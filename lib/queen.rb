require_relative "figure"

class Queen < Figure

  def initialize(pos)
    super(pos)
    @game_symbol = "♛"
  end
end
