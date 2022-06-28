require_relative "piece"

class Pawn < Piece
  attr_accessor :jump
  attr_accessor :moves

  def initialize(color, position, board)
    super(color, position, board)
    @moves = 0
    @token = "♟ "
    @directions_black = [[1, 0], [2, 0], [1, -1], [1, 1]]
    @directions_white = [[-1, 0], [-2, 0], [-1, 1], [-1, -1]]
    @jump = false
  end

  def jumped?
    @jump
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
      middle_x = direction[0] > 0 ? 1 : -1

      if !@board.cell_is_empty?([position[0] + middle_x, position[1]])
        return false
      end
    end

    # can't moves diagonal to empty cells 
    if @board.cell_is_empty?(destination) and direction[1] != 0
      return false
    end


    return true

  end

  def get_direction(from, to)
    #first move
    if @moves == 0
      if ((to[0] - from[0]).abs == 2) and (to[1] == from[1])
        case @color
        when :no_color
          return [-2, 0]
        when :black
          return [2, 0]
        end

      elsif (to[0] - from[0]).abs == 1 and (to[1] - from[1]).abs == 1
        return [ to[0] - from[0], to[1] - from[1] ]
      else
        return []
      end
    else
      if ((to[0] - from[0]).abs == 1) and (to[1] == from[1])
        case @color
        when :no_color
          return [-1, 0]
        when :black
          return [1, 0]
        end
      elsif (to[0] - from[0]).abs == 1 and (to[1] == from[1]).abs == 1
        return [ to[0] - from[0], to[1] - from[1] ]
      else
        return []
      end
    end
    return []
  end

end
