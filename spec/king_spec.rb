require "./lib/king.rb"
require "./lib/board.rb"
require "./lib/bishop.rb"
require "./lib/rook.rb"

describe King do

  describe "#in_check?" do
    it "returns true if king in check - top" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      rook = Rook.new(:no_color, [1, 3], board)
      board.set_piece(rook, [1, 3])

      res = king.in_check?
      expect(res).to be true
    end

    it "returns true if king in check - bottom" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      rook = Rook.new(:no_color, [6, 3], board)
      board.set_piece(rook, [6, 3])

      res = king.in_check?
      expect(res).to be true
    end

    it "returns true if king in check - right" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      rook = Rook.new(:no_color, [3, 5], board)
      board.set_piece(rook, [3, 5])

      res = king.in_check?
      expect(res).to be true
    end

    it "returns true if king in check - left" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      rook = Rook.new(:no_color, [3, 1], board)
      board.set_piece(rook, [3, 1])

      res = king.in_check?
      expect(res).to be true
    end
  end

  describe "#can_move?" do
    it "returns false if dest piece has same color" do
      board = Board.new
      board.fill()
      piece = board.get_piece([0, 4])
      destination = [1, 4]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if length of move is more than 1" do
      board = Board.new
      piece = King.new(:black, [2, 2], board)
      board.set_piece(piece, [2, 2])
      destination = [4, 4]
      res = piece.can_move?(destination)
      expect(res).to be false
    end

    it "returns true if length of move is 1" do
      board = Board.new
      piece = King.new(:black, [3, 3], board)
      board.set_piece(piece, [3, 3])
      destination = [4, 4]
      res = piece.can_move?(destination)
      expect(res).to be true
    end

  end

  describe "#is_danger?" do
    #left and right
    it "returns true if piece will be in danger zone - right" do
      board = Board.new
      piece = King.new(:black, [2, 2], board)
      board.set_piece(piece, [2, 2])

      enemy_b = Rook.new(:no_color, [5, 3], board)
      board.set_piece(enemy_b, [5, 3])

      destination = [2, 3]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - left" do
      board = Board.new
      piece = King.new(:black, [2, 2], board)
      board.set_piece(piece, [2, 2])

      enemy_b = Rook.new(:no_color, [5, 1], board)
      board.set_piece(enemy_b, [5, 1])

      destination = [2, 1]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - bottom" do
      board = Board.new
      piece = King.new(:black, [2, 2], board)
      board.set_piece(piece, [2, 2])

      enemy_b = Rook.new(:no_color, [3, 0], board)
      board.set_piece(enemy_b, [3, 0])

      destination = [3, 2]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    #top and bottom
    it "returns true if piece will be in danger zone - top" do
      board = Board.new
      piece = King.new(:black, [4, 4], board)
      board.set_piece(piece, [4, 4])

      enemy_b = Rook.new(:no_color, [3, 0], board)
      board.set_piece(enemy_b, [3, 0])

      destination = [3, 4]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - top-right" do
      board = Board.new
      piece = King.new(:black, [4, 4], board)
      board.set_piece(piece, [4, 4])

      enemy_b = Bishop.new(:no_color, [5, 7], board)
      board.set_piece(enemy_b, [5, 7])

      destination = [3, 5]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - bottom-right" do
      board = Board.new
      piece = King.new(:black, [4, 4], board)
      board.set_piece(piece, [4, 4])

      enemy_b = Bishop.new(:no_color, [3, 7], board)
      board.set_piece(enemy_b, [3, 7])

      destination = [5, 5]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - top-left" do
      board = Board.new
      piece = King.new(:black, [4, 4], board)
      board.set_piece(piece, [4, 4])

      enemy_b = Bishop.new(:no_color, [5, 1], board)
      board.set_piece(enemy_b, [5, 1])

      destination = [3, 3]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end

    it "returns true if piece will be in danger zone - bottom-left" do
      board = Board.new
      piece = King.new(:black, [4, 4], board)
      board.set_piece(piece, [4, 4])

      enemy_b = Bishop.new(:no_color, [3, 1], board)
      board.set_piece(enemy_b, [3, 1])

      destination = [5, 3]
      res = piece.is_danger?(destination)
      expect(res).to be true
    end
  end
end
