require "./lib/pawn.rb"
require "./lib/rook.rb"
require "./lib/board.rb"
require "./lib/player.rb"

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

    it "returns true if piece can eats another moving to diagonal" do
      board = Board.new
      board.fill()
      player_w = Player.new(:white)
      player_b = Player.new(:black)
      board.move("e2-e4", player_w)
      board.move("d7-d5", player_b)
      res = board.move("e4-d5", player_w)
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

    it "returns true if piece can eats another one to diagonally - en passant" do
      board = Board.new
      board.fill()

      piece = Pawn.new(:black, [3, 0], board)
      piece.moves += 1
      piece.jump = true
      board.set_piece(piece, [3, 0])

      piece_attacker = Pawn.new(:no_color, [3, 1], board)
      piece_attacker.moves += 3
      piece_attacker.jump = true
      board.set_piece(piece_attacker, [3, 1])

      res = piece_attacker.can_move?([2, 0])
      expect(res).to be true
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
