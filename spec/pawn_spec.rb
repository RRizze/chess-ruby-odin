require "./lib/pawn.rb"
require "./lib/rook.rb"
require "./lib/board.rb"

describe Pawn do

  describe "#can_move?" do

    it "returns false if dest piece has same color" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 1])
      another_piece = Pawn.new(:black, [2, 2], board)
      board.set_piece(another_piece, [2, 2])
      destination = [2, 2]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant moves for incorrect direction" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 1])
      destination = [3, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if piece moves two cells in the first move" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 0])
      destination = [3, 0]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

    it "returns false if piece can't moves two cells in the second move" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 0])
      piece.moves += 1
      destination = [3, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if piece can eat another moving to diagonal" do
      board = Board.new
      board.fill()
      another_piece = Rook.new(:no_color, [2, 1], board)
      piece = board.get_piece([1, 0])
      board.set_piece(another_piece, [2, 1])
      destination = [2, 1]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

    it "returns false if piece can't moves to diagonal if there's no pieces" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 0])
      destination = [2, 1]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if piece cant jumps over another figure" do
      board = Board.new
      board.fill()
      piece = board.get_piece([1, 0])
      another_piece = Rook.new(:no_color, [2, 0], board)
      board.set_piece(another_piece, [2, 0])
      destination = [3, 0]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

  end
end
