require_relative "figure"

class Rook < Figure

  def initialize(color)
    super(color)
    @token = "♜ "
    @directions = []
  end
end
