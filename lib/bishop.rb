require_relative "piece"

class Bishop < Piece

  def initialize(color)
    super(color)
    @token = "♝ "
    @directions = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end
