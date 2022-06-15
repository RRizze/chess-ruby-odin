require_relative "piece"

class King < Piece

  def initialize(color)
    super(color)
    @token = "♚ "
    @directions = [
      [-1, 0], [1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [1, -1], [-1, -1]
    ]
  end
end
