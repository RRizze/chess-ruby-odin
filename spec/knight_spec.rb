require "./lib/knight.rb"
require "./lib/board.rb"

describe Knight do

  describe "#can_move?" do
    it "returns false if piece cant move if same piece is there" do
      board = Board.new
      piece = board.get_piece([0, 1])
      destination = [1, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant moves to a straigh line" do
      board = Board.new
      piece = Knight.new(:black, [3, 0], board)
      destination = [4, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant move to a diagonal line" do
      board = Board.new
      piece = Knight.new(:black, [3, 0], board)
      destination = [4, 1]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if piece can jump over" do
      board = Board.new
      piece = board.get_piece([0, 1])
      destination = [2, 2]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

    it "returns false if piece cant do big jump" do
      board = Board.new
      piece = board.get_piece([0, 1])
      destination = [3, 2]
      res = piece.can_move?(destination)
      expect(res).to be false
    end
  end
end
