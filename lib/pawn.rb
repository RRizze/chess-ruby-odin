require_relative "piece"

class Pawn < Piece
  attr_accessor :jump
  attr_accessor :moves

  def initialize(color)
    super(color)
    @moves = 0
    @token = "♟ "
    @directions = [[1, 0]] 
    @diag_moves_black = [[1, -1], [1, 1]]
    @diag_moves_white = [[-1, -1], [-1, 1]]
    @first_move = [[2, 0]]
    @jump = false
  end

  def jumped?
    @jump
  end

  def get_directions(has_diag = false)
    #first move
    if @moves == 0
      if @color == :black
        if has_diag
          return @directions + @first_move + @diag_moves_black
        else
          return @directions + @first_move
        end
      else
        arr = @directions + @first_move
        res = arr.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          [x, y]
        end

        if has_diag
          return res + @diag_moves_white
        else
          return res
        end
      end
    # not first move
    else
      if @color == :black
        if has_diag
          return @directions + @diag_moves_black
        else
          return @directions
        end
      else
        res = @directions.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          [x, y]
        end

        if has_diag
          return res + @diag_moves_white
        else
          return res
        end
      end
    end
  end

end
