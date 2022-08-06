require_relative "figure"

class Pawn < Figure

  def initialize(color)
    super(color)
    @token = "♟ "
    @direction = []
  end

end
