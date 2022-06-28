require "./lib/king.rb"
require "./lib/board.rb"

describe King do
    it "returns false if dest piece has same color" do
      board = Board.new
      piece = board.get_piece([0, 4])
      destination = [1, 4]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    xit "returns false if piece cant moves for incorrect direction" do
      board = Board.new
      piece = board.get_piece([1, 1])
      destination = [3, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end
end
