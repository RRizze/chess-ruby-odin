require "./lib/pawn.rb"

describe Pawn do

  describe "#get_directions" do
    it "returns directions+first_move reverse if color is white" do
      pawn = Pawn.new(:no_color)
      res = pawn.get_directions
      expect(res).to eq([[-1, 0], [-2, 0]])
    end
  end
end
