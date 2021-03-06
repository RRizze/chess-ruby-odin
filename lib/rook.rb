require_relative "piece"

class Rook < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♜ "
    @directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end

  def get_fen
    (@color == :black) ? "r" : "R"
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

    # false if movement is a not straight line
    if !@directions.include?(direction)
      return false
    end

    # find out if path is empty - no other pieces in the way
    if direction[0] == 0
      spaces_to_move = (@position[1] - destination[1]).abs

      (1..spaces_to_move).each do |step|
        new_pos = [
          @position[0],
          @position[1] + direction[1] * step
        ]
        if !@board.cell_is_empty?(new_pos) and step < spaces_to_move
          return false
        end
      end
    end

    if direction[1] == 0
      spaces_to_move = (@position[0] - destination[0]).abs

      (1..spaces_to_move).each do |step|
        new_pos = [
          @position[0] + direction[0] * step,
          @position[1],
        ]
        if !@board.cell_is_empty?(new_pos) and step < spaces_to_move
          return false
        end
      end
    end

    # TRACK CASTLING
    if !@did_move
      if @position == [0, 0]
        @board.castling = "kKQ"
      elsif @position == [0, 7]
        @board.castling = "qKQ"
      elsif @position == [7, 0]
        @board.castling = "kqK"
      elsif @position == [7, 7]
        @board.castling = "kqQ"
      end
    end

    return true
  end
end
