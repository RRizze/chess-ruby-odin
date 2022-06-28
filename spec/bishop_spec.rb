require "./lib/bishop.rb"
require "./lib/board.rb"

describe Bishop do

  describe "#can_move?" do
    it "returns false if piece cant moves if same piece is there" do
      board = Board.new
      piece = board.get_piece([0, 2])
      destination = [1, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant jumps over" do
      board = Board.new
      piece = board.get_piece([0, 2])
      destination = [2, 4]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant moves to a straigh line" do
      board = Board.new
      piece = Bishop.new(:black, [3, 0], board)
      destination = [4, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if the path is clear and it can moves to a diagonal" do
      board = Board.new
      piece = Bishop.new(:black, [3, 0], board)
      destination = [4, 1]
      res = piece.can_move?(destination)
      expect(res).to be true
    end
  end
end
