require_relative "piece"

class King < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♚ "
    @directions = [
      [-1, 0], [1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [1, -1], [-1, -1]
    ]
  end

  def can_move?(destination)
    # false if piece at the destination has same color
    possible_piece = @board.get_piece(destination)

    if !possible_piece
      if possible_piece.color == @color
        return false
      end
    end

    # false if movement is not diagonal or straight line
    if (@position[0] - destination[0]).abs != (@position[1] - destination[1]).abs and (@position[0] != destination[0] and @position[1] != destination[1])
      return false
    end

    # false if length of move is more than 1
    if (@position[0] - destination[0]).abs > 1 || (@position[1] - destination[1]).abs > 1
      return false
    end

  
    direction = @board.get_direction(@position, destination)

    # can't move to the danger zone
    danger = is_danger?(destination)

    return true
  end

  def is_danger?(destination)
    dest_row = destination[0]
    dest_col = destination[1]

    # straight lines
    (dest_row+1..7).each do |row|
      if @board.cell_is_empty?([row, dest_col])
        next
      else
        piece = @board.get_piece([row, dest_col])

        if piece.color == @color
          break;
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
    end

    row_down = dest_row - 1
    while row_down >= 0
      if @board.cell_is_empty?([row_down, dest_col])
        row_down -= 1
        next
      else
        piece = @board.get_piece([row_row, dest_col])

        if piece.color == @color
          break;
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      row_down -= 1
    end

    (dest_col+1..7).each do |col|
      if @board.cell_is_empty?([dest_row, col])
        next
      else
        piece = @board.get_piece([dest_row, col])

        if piece.color == @color
          break;
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
    end

    col_down = dest_col - 1
    while col_down >= 0
      if @board.cell_is_empty?([dest_row, col_down])
        col_down -= 1
        next
      else
        piece = @board.get_piece([dest_row, col_down])

        if piece.color == @color
          break;
        elsif piece.is_a?(Rook) or piece.is_a?(Queen)
          return true
        end
      end
      col_down -= 1
    end

    # check giagonals
    # bottom-right ++
    (dest_row..7).each do |row|
      (dest_col+1..7).each do |col|
        if @board.cell_is_empty?([row, col])
          next
        else
          piece = @board.get_piece([row, col])
          
          if piece.color == @color
            break;
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
      end
    end

    # top-left --
    start_pos = [dest_x - 1, dest_y]
    while start_pos[0] >= 0 and start[1] >= 0
      piece = @board.get_piece(start_pos)

      if piece.color == @color
        next;
      elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
        return true
      end
      start_pos = [start_pos[0] - 1, start_pos[1] - 1]
    end
    
    return false
  end
end
