require_relative "figure"

class Bishop < Figure

  def initialize(color)
    super(color)
    @token = "♝ "
    @directions = []
  end
end
