require_relative "piece"

class Queen < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♛ "
    @directions = [
      [1, 0], [-1, 0], [0, 1], [0, -1],
      [1, 1], [1, -1], [-1, 1], [-1, -1]
    ]
  end

  def can_move?(destination)
    # false if same colors
    possible_piece = @board.get_piece(destination)

    if possible_piece
      if possible_piece.color == @color
        return false
      end
    end

    # find direction to move
    direction = @board.get_direction(@position, destination)

    # false if movement is a not straight or diagonal line
    if !@directions.include?(direction)
      return false
    end

    # find out if path is empty - no other pieces in the way
    spaces_to_move = [
      (@position[0] - destination[0]).abs,
      (@position[1] - destination[1]).abs,
    ].max

    (1..spaces_to_move).each do |step|
      new_pos = [
        @position[0] + direction[0] * step,
        @position[1] + direction[1] * step
      ]

      if !@board.cell_is_empty?(new_pos)
        return false
      end
    end

    return true
  end
end
