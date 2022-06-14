require_relative "figure"

class Pawn < Figure

  def initialize(color)
    super(color)
    @token = "♟ "
    @directions = [[1, 0]]
    @first_move = [[2, 0]]
  end

  def get_directions
    #first move
    if !@has_move
      @has_move = false
      if @color == :black
        return @directions + @first_move
      else
        res = @directions + @first_move
        res = res.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          return [x, y]
        end
        return res
      end
    # not first move
    else
      if @color == :black
        return @directions
      else
        res = @directions
        res = res.map do |move|
          x = move[0] * (-1)
          y = move[1] * (-1)
          return [x, y]
        end
        return res
      end
    end
  end

end
