class Figure
  attr_reader :color, :directions
  attr_accessor :token

  def initialize(color)
    @token = ""
    @directions = []
    @color = color
  end

end
