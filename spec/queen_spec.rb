require "./lib/queen.rb"
require "./lib/board.rb"

describe Queen do

  describe "#can_move?" do
    it "returns false if piece cant moves if same piece is there" do
      board = Board.new
      board.fill()
      piece = board.get_piece([0, 3])
      destination = [1, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if piece can moves to a straigh line" do
      board = Board.new
      piece = Queen.new(:black, [3, 0], board)
      destination = [4, 0]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

    it "returns true if the path is clear and it can moves to a diagonal" do
      board = Board.new
      piece = Queen.new(:black, [3, 0], board)
      destination = [5, 2]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

    it "returns false if piece cant jumps over" do
      board = Board.new
      board.fill()
      piece = board.get_piece([0, 3])
      destination = [2, 3]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if piece can eats another one" do
      board = Board.new
      queen = Queen.new(:black, [3, 7], board)
      destination = [1, 5]
      pawn = Pawn.new(:no_color, destination, board)
      board.set_piece(queen, [3, 7])
      board.set_piece(pawn, destination)
      res = queen.can_move?(destination)
      expect(res).to be true
    end

  end
end
