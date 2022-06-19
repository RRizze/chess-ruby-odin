require "./lib/pawn.rb"

describe Pawn do

  describe "#get_directions" do
    it "returns directions+first_move if color is white" do
      pawn = Pawn.new(:no_color)
      res = pawn.get_directions(false)
      expect(res).to eq([[-1, 0], [-2, 0]])
    end

    it "returns full directions for color white" do
      pawn = Pawn.new(:no_color)
      res = pawn.get_directions(true)
      expect(res).to eq([[-1, 0], [-2, 0], [-1, -1], [-1, 1]])
    end

    it "returns directions+first_move if color is black" do
      pawn = Pawn.new(:black)
      res = pawn.get_directions(false)
      expect(res).to eq([[1, 0], [2, 0]])
    end

    it "returns full directions for color black" do
      pawn = Pawn.new(:black)
      res = pawn.get_directions(true)
      expect(res).to eq([[1, 0], [2, 0], [1, -1], [1, 1]])
    end
  end
end
