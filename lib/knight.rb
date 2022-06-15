require_relative "piece"

class Knight < Piece

  def initialize(color)
    super(color)
    @token = "♞ "
    @directions = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [-1, 2], [1, -2], [-1, -2]
    ]
  end
end
