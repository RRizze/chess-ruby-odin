class Figure
  attr_reader :game_symbol
  attr_reader :start_pos
  attr_accessor :position

  def initialize(pos)
    @game_symbol = ""
    @start_position = pos
    @position = pos
  end

end
