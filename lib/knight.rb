require_relative "figure"

class Knight < Figure

  def initialize(color)
    super(color)
    @token = "♞ "
    @directions = []
  end
end
