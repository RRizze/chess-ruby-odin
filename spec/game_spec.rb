require "./lib/game.rb"
require "./lib/board.rb"
require "./lib/player.rb"

describe Game do

  describe "#clear_screen" do
    it "clears the screen" do
    end
  end

  describe "#generate_fen" do
    it "returns fen notation for first move" do
      game = Game.new
      board = Board.new
      board.fill()
      king_w = board.get_piece([0, 4])
      king_b = board.get_piece([7, 4])
      players = [Player.new(:white, king_w), Player.new(:black, king_b)]

      res = game.generate_fen(board)
      start = "rnbqkbnr\\pppppppp\\8\\8\\8\\8\\PPPPPPPP\\RNBQKBNR w KQkq - 0 1"
      expect(res).to eq(start)

    end
  end

  describe "#clear_lines" do
    it "clears the screen from the n line to the end" do
    end
  end

  describe "#pvp_start" do
  end

  describe "#ai_start" do
  end

  describe "#loop" do
  end
end
