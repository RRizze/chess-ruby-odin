require "./lib/king.rb"
require "./lib/board.rb"
require "./lib/bishop.rb"
require "./lib/rook.rb"

describe King do

  describe "#checkmate?" do
    it "returns false if no checkmate or check" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      bishop = Bishop.new(:no_color, [6, 1], board)
      board.set_piece(bishop, [6, 1])

      queen = Queen.new(:no_color, [2, 7], board)
      board.set_piece(queen, [2, 7])

      rook = Rook.new(:no_color, [4, 0], board)
      board.set_piece(rook, [4, 0])

      pawn1 = Pawn.new(:black, [3, 2], board)
      board.set_piece(pawn1, [3, 2])

      pawn2 = Pawn.new(:black, [3, 4], board)
      board.set_piece(pawn2, [3, 4])

      res = king.checkmate?
      expect(res).to be false
    end

    it "returns :check if check" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      bishop = Bishop.new(:no_color, [6, 1], board)
      board.set_piece(bishop, [6, 1])

      queen = Queen.new(:no_color, [2, 7], board)
      board.set_piece(queen, [2, 7])

      rook1 = Rook.new(:no_color, [0, 3], board)
      board.set_piece(rook1, [0, 3])

      rook2 = Rook.new(:no_color, [4, 0], board)
      board.set_piece(rook2, [4, 0])

      res = king.checkmate?
      expect(res).to eq(:check)
    end

    it "returns :checkmate if checkmate" do
      board = Board.new
      king = King.new(:black, [0, 4], board)
      board.set_piece(king, [0, 4])

      queen_b = Queen.new(:black, [0, 3], board)
      board.set_piece(queen_b, [0, 3])

      bishop_b = Bishop.new(:black, [0, 5], board)
      board.set_piece(bishop_b, [0, 5])

      pawn_b = Pawn.new(:black, [1, 3], board)
      board.set_piece(pawn_b, [1, 3])

      #whites
      bishop = Bishop.new(:no_color, [4, 2], board)
      board.set_piece(bishop, [4, 2])

      queen = Queen.new(:no_color, [1, 5], board)
      board.set_piece(queen, [1, 5])

      res = king.checkmate?
      expect(res).to eq(:checkmate)
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

    # castling
    it "returns true if king can do long castling" do
      board = Board.new
      board.castling = "kqKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 0], board)
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 0])
      destination = [0, 2]
      res = king.can_move?(destination)
      expect(res).to be true
    end

    it "returns true if king can do short castling" do
      board = Board.new
      board.castling = "kqKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 7], board)
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 7])
      destination = [0, 6]
      res = king.can_move?(destination)
      expect(res).to be true
    end

    it "returns false if king can't do long castling" do
      board = Board.new
      board.castling = "kqKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 0], board)
      queen = Queen.new(:black, [0, 3], board)
      board.set_piece(queen, [0, 3])
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 7])
      destination = [0, 2]
      res = king.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if king can't do long castling" do
      board = Board.new
      board.castling = "kKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 0], board)
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 7])
      destination = [0, 2]
      res = king.can_move?(destination)
      expect(res).to be false
    end


    it "returns false if king can't do short castling" do
      board = Board.new
      board.castling = "kqKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 0], board)
      king.did_move = true
      rook.did_move = true
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 7])
      destination = [0, 6]
      res = king.can_move?(destination)
      expect(res).to be false
    end

    it "returns false if king can't do short castling" do
      board = Board.new
      board.castling = "qKQ"
      king = King.new(:black, [0, 4], board)
      rook = Rook.new(:black, [0, 0], board)
      board.set_piece(king, [0, 4])
      board.set_piece(rook, [0, 7])
      destination = [0, 6]
      res = king.can_move?(destination)
      expect(res).to be false
    end
  end
  describe "#line_is_danger?" do

    it "#return true if line is under attack - Rook" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      rook = Rook.new(:no_color, [4, 0], board)
      board.set_piece(rook, [4, 0])
      # we move from top to bottom and check left and right sides
      add_vector = [0, -1] # check LEFT side OF target point
      target = [4, 3]
      res = king.line_is_danger?(target, add_vector)
      expect(res).to be true
    end

    it "#return true if line is under attack - Queen" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      queen = Queen.new(:no_color, [4, 0], board)
      board.set_piece(queen, [4, 0])
      # we move from top to bottom and check left and right sides
      add_vector = [0, -1] # check LEFT side OF target point
      target = [4, 3]
      res = king.line_is_danger?(target, add_vector)
      expect(res).to be true
    end

    it "#return true if line is under attack - Bishop" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      bishop = Bishop.new(:no_color, [5, 3], board)
      board.set_piece(bishop, [5, 3])
      # we move to bot-right [1, 1] and check left and right parts of diagonal
      add_vector = [1, -1] # check BOTTOM-LEFT side OF target point
      target = [4, 4]
      res = king.line_is_danger?(target, add_vector)
      expect(res).to be true
    end

    it "#return true if line is under attack - Pawn" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      pawn = Pawn.new(:no_color, [5, 3], board)
      board.set_piece(pawn, [5, 3])
      # we move to bot-right [1, 1] and check left and right cells
      # as neighbors in diagonal
      add_vector = [1, -1] # check BOTTOM-LEFT cell
      target = [4, 4]
      res = king.line_is_danger?(target, add_vector)
      expect(res).to be true
    end

    it "#return true if line is under attack - Pawn" do
      board = Board.new
      king = King.new(:black, [3, 3], board)
      board.set_piece(king, [3, 3])

      pawn = Pawn.new(:no_color, [5, 5], board)
      board.set_piece(pawn, [5, 5])
      # we move to bot-right [1, 1] and check left and right cells
      # as neighbors in diagonal
      add_vector = [1, 1] # check BOTTOM-RIGHT cell
      target = [4, 4]
      res = king.line_is_danger?(target, add_vector)
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
