require_relative "piece"

class Pawn < Piece
  attr_accessor :jump

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♟ "
    @directions_black = [[1, 0], [2, 0], [1, -1], [1, 1]]
    @directions_white = [[-1, 0], [-2, 0], [-1, 1], [-1, -1]]
    @jump = false
  end

  def get_fen
    (@color == :black) ? "p" : "P"
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

    if direction.length == 0
      return false
    end

    # can't jump over pieces
    if direction[0].abs == 2
      #from 5 to 3 -> middle is 4
      middle_x = direction[0] > 0 ? 1 : -1

      if !@board.cell_is_empty?([position[0] + middle_x, position[1]])
        return false
      end
    end

    # can't moves diagonally to empty cells  except en passant
    if @board.cell_is_empty?(destination) and direction[1] != 0
      pawn_pos = [@position[0], @position[1] + (destination[1] - @position[1])]
      if pawn_pos != @board.en_passant_pos
        return false
      else
        @board.remove_piece(pawn_pos)
        # CLEAR EN_PASSANT
        @board.en_passant_pos = "-"
        return true
      end
    end

    return true
  end

  def get_direction(from, to)
    row = to[0] - from[0]
    col = to[1] - from[1]

    if row.abs > 2 or col.abs > 2
      return []
    end

    if (row.abs == 2 and col == 0 and from[0] == 1 and @color == :black) or
        (row.abs == 2 and col == 0 and from[0] == 6 and @color == :no_color)
      # SET EN_PASSANT
      @board.en_passant_pos = to
      return [row, col]
    elsif (row.abs == 2 and col == 0 and from[0] != 1 and @color == :black) or
      (row.abs == 2 and col == 0 and from[0] != 6 and @color == :no_color)
      return []
    end

    return [row, col]
  end

end
