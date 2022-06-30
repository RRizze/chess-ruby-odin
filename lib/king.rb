require_relative "piece"
require_relative "rook"
require_relative "queen"
require_relative "bishop"

class King < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♚ "
    @directions = [
      [-1, 0], [1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [1, -1], [-1, -1]
    ]
  end

  def in_check?
    # check top
    #return true if danger_line?(@position, [-1, 0], :non_diagonal)
    start_pos = [@position[0] - 1, @position[1]]

    while start_pos[0] >= 0
      if @board.cell_is_empty?(start_pos)
        start_pos = [start_pos[0] - 1, start_pos[1]]
        next
      else
        piece = @board.get_piece(start_pos)

        if piece.color == @color
          break
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      start_pos = [start_pos[0] - 1, start_pos[1]]
    end

    # check bottom
    start_pos = [@position[0] + 1, @position[1]]

    while start_pos[0] < 8
      if @board.cell_is_empty?(start_pos)
        start_pos = [start_pos[0] + 1, start_pos[1]]
        next
      else
        piece = @board.get_piece(start_pos)

        if piece.color == @color
          break
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      start_pos = [start_pos[0] + 1, start_pos[1]]
    end

    #check right
    start_pos = [@position[0], @position[1] + 1]

    while start_pos[1] < 8
      if @board.cell_is_empty?(start_pos)
        start_pos = [start_pos[0], start_pos[1] + 1]
        next
      else
        piece = @board.get_piece(start_pos)

        if piece.color == @color
          break
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      start_pos = [start_pos[0], start_pos[1] + 1]
    end

    #check left
    start_pos = [@position[0], @position[1] - 1]

    while start_pos[1] >= 0
      if @board.cell_is_empty?(start_pos)
        start_pos = [start_pos[0], start_pos[1] - 1]
        next
      else
        piece = @board.get_piece(start_pos)

        if piece.color == @color
          break
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      start_pos = [start_pos[0], start_pos[1] - 1]
    end

    return false
  end

  def can_move?(destination)
    # false if piece at the destination has same color
    possible_piece = @board.get_piece(destination)

    if possible_piece
      if possible_piece.color == @color
        return false
      end
    end

    # false if length of move is more than 1
    if (@position[0] - destination[0]).abs != 1 or (@position[1] - destination[1]).abs != 1
      return false
    end

    direction = get_direction(@position, destination)

    # false if dir is incorrect
    # get_direction always return unit vector, so is this condition redundant?
    if !@directions.include?(direction)
      return false
    end

    # can't move to the danger zone
    return !is_danger?(destination)
  end

  def is_danger?(to)
    from = @position
    direction = get_direction(from, to)

    case direction
    # right and left direction
    when [0, 1], [0, -1]

      start_row = to[0] + 1
      start_col = to[1]

      (start_row..7).each do |row|
        if @board.cell_is_empty?([row, start_col])
          next
        else
          piece = @board.get_piece([row, start_col])

          if piece.color == @color
            break
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
      end

      start_row = to[0] - 1
      start_col = to[1]
      while start_row >= 0
        if @board.cell_is_empty?([start_row, start_col])
          start_row -= 1
          next
        else
          piece = @board.get_piece([start_row, start_col])

          if piece.color == @color
            break
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
        start_row -= 1
      end

    # top and bot
    when [1, 0], [-1, 0]

      start_pos = [to[0], to[1] + 1]
      while start_pos[1] < 8
        if @board.cell_is_empty?(start_pos)
          start_pos = [start_pos[0], start_pos[1] + 1]
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos = [start_pos[0], start_pos[1] + 1]
      end

      start_pos = [to[0], to[1] - 1]
      while start_pos[1] >= 0
        if @board.cell_is_empty?(start_pos)
          start_pos = [start_pos[0], start_pos[1] - 1]
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break;
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos [start_pos[0], start_pos[1] - 1]
      end

    # top-right and bottom-left
    when [-1, 1], [1, -1]
      # check top-left part of diagonal
      start_p = [to[0] - 1, to[1] - 1]

      while start_p[0] >= 0 and start_p[1] >= 0
        if @board.cell_is_empty?(start_p)
          start_p = [start_p[0] - 1, start_p[1] - 1]
          next
        else
          piece = @board.get_piece(start_p)

          if piece.color == @color
            break;
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_p = [start_p[0] - 1, start_p[1] - 1]
      end

      # check bottom-right part of diagonal
      start_p = [to[0] + 1, to[1] + 1]

      while start_p[0] < 8 and start_p[1] < 8
        if @board.cell_is_empty?(start_p)
          start_p = [start_p[0] + 1, start_p[1] + 1]
          next
        else
          piece = @board.get_piece(start_p)

          if piece.color == @color
            break;
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_p = [start_p[0] + 1, start_p[1] + 1]
      end

    # bottom-right and top-left
    when [1, 1], [-1, -1]
      # check top-right part of diagonal
      start_p = [to[0] - 1, to[1] + 1]

      while (start_p[0] >= 0 and start_p[1] < 8)
        if @board.cell_is_empty?(start_p)
          start_p = [start_p[0] - 1, start_p[1] + 1]
          next
        else
          piece = @board.get_piece(start_p)

          if piece.color == @color
            break

          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_p = [start_p[0] - 1, start_p[1] + 1]
      end

      # check bottom-left part of diagonal
      start_p = [to[0] + 1, to[1] - 1]

      while (start_p[0] < 8 and start_p[1] >= 0)
        if @board.cell_is_empty?(start_p)
          start_p = [start_p[0] + 1, start_p[1] - 1]
          next
        else
          piece = @board.get_piece(start_p)

          if piece.color == @color
            break
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_p = [start_p[0] + 1, start_p[1] - 1]
      end
    end

    return false
  end
end
