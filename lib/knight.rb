require_relative "piece"

class Knight < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♞ "
    @directions = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [-1, 2], [1, -2], [-1, -2]
    ]
  end

  def get_direction(from, to)
    if ((to[0] - from[0]).abs == 2 and (to[1] - from[1]).abs == 1) or
      ((to[0] - from[0]).abs == 1 and (to[1] - from[1]).abs == 2)
      return [ to[0] - from[0], to[1] - from[1] ]
    else
      return []
    end
  end

  def can_move?(destination)
    # false if piece at the destination has same color
    possible_piece = @board.get_piece(destination)

    if possible_piece
      if possible_piece.color == @color
        return false
      end
    end

    # find direction to move
    direction = get_direction(@position, destination)

    # false if movement is not a diagonal line
    if direction.length == 0
      return false
    end

    return true
  end
end
