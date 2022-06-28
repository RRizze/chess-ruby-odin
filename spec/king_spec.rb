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

    it "returns false if length of move is more than 1" do
      board = Board.new
      piece = King.new(:black, [2, 2], board)
      destination = [4, 4]
      res = piece.can_move?(destination)
      expect(res).to be false
    end
end
