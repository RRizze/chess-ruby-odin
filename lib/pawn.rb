require_relative "piece"

class Pawn < Piece
  attr_reader :has_move

  def initialize(color)
    super(color)
    @has_move = false
    @token = "♟ "
    @directions = [[1, 0]]
    @first_move = [2, 0]
  end

  def get_directions
    #first move
    if !@has_move
      @has_move = true
      if @color == :black
        res = @directions
        res.push(@first_move)
        return res
      else
        arr = @directions
        arr.push(@first_move)
        res = arr.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          [x, y]
        end
        return res
      end
    # not first move
    else
      if @color == :black
        return @directions
      else
        arr = @directions
        res = arr.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          [x, y]
        end
        return res
      end
    end
  end

end
