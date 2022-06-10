class Figure
  attr_accessor :token
  attr_reader :directions
  attr_accessor :color

  def initialize(color)
    @token = ""
    @directions = []
    @color = color
  end

end
