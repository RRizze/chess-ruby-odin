class Figure
  attr_reader :token
  attr_reader :directions
  attr_accessor :color

  def initialize(color)
    @token = ""
    @directions = []
    @color = color
  end


  def set_token(token)
    @token = token
  end

end
