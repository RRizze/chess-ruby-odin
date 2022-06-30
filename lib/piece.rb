require_relative "color"

class Piece
  include Color

  attr_reader :directions, :token, :token_bg
  attr_accessor :position, :color

  def initialize(color, position, board)
    @token = ""
    @directions = []
    @color = color
    @position = position
    @board = board
  end

  def set_token_bg(bg)
    @token_bg = colorize(@token, @color, bg)
  end

  def get_unit_vector(pos)
    x = pos[0] == 0 ? 0 : pos[0] / (pos[0]).abs
    y = pos[1] == 0 ? 0 : pos[1] / (pos[1]).abs

    return [x, y]
  end

  def get_direction(from, to)
    new_pos = [
      to[0] - from[0],
      to[1] - from[1]
    ]

    return get_unit_vector(new_pos)
  end

  def sum_vec(v1, v2)
    return [
      v1[0] + v2[0],
      v1[1] + v2[1]
    ]
  end

  def danger_line?(pos, add_vector, direction)
    if direction == :non_diagonal
      #start_pos = [pos[0] + direction[0], pos[1] + direction[1]]
      start_pos = sum_vec(pos, add_vector)
      while (start_pos[0] >= 0 and start_pos[0] < 8 and
          start_pos[1] >= 0 and start_pos[1] < 8)
        
        if @board.cell_is_empty?(start_pos)
          start_pos = sum_vec(start_pos, add_vector)
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break;
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos = sum_vec(start_pos, add_vector)
      end
    else
      #diagonal
      start_pos = sum_vec(pos, add_vector)
      #start_pos = [pos[0] + direction[0], pos[1] + direction[1]]
      while (start_pos[0] >= 0 and start_pos[0] < 8 and
          start_pos[1] >= 0 and start_pos[1] < 8)
        
        if @board.cell_is_empty?(start_pos)
          start_pos = sum_vec(start_pos, add_vector)
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break;
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos = sum_vec(start_pos, add_vector)
      end
    end

    return false
  end

end
