require "./lib/rook.rb"
require "./lib/board.rb"

describe Rook do

  describe "#can_move?" do
    it "returns false if piece cant moves if same piece is there" do
      board = Board.new
      board.fill()
      piece = board.get_piece([0, 0])
      destination = [1, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant jumps over" do
      board = Board.new
      board.fill()
      piece = board.get_piece([0, 0])
      destination = [2, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant moves diagonal" do
      board = Board.new
      piece = Rook.new(:black, [3, 0], board)
      destination = [5, 5]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if the path is clear" do
      board = Board.new
      piece = Rook.new(:black, [3, 0], board)
      destination = [5, 0]
      res = piece.can_move?(destination)
      expect(res).to be true
    end
  end
end
