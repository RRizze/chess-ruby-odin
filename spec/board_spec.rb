require "./lib/board.rb"
require "./lib/queen.rb"

describe Board do

  context "Coloring text" do
    describe "#colorize" do
      # how can i test it?
    end
  end

  describe "#print_board" do
    xit "should print the board" do
      # how can i test it?
    end
  end

  describe "#set_cell" do
    it "changes game symbol if move is legal" do
      pos = [4, 4]
      queen = Queen.new(pos)
      board = Board.new
      board.set_cell(queen)
      # change game_symbol for...  .get_symbol, .sign, .to_s, .to_str
      expect(board.board[pos[0] * 7 + pos[1]].content).to be(queen.game_symbol)
    end
  end

  describe "#cell_free?" do
    it "returns true if cell is empty" do
      pos = [4, 4]
      board = Board.new
      res = board.cell_empty?(pos)
      expect(res).to be true
    end

    it "returns flase if cell is not empty" do
      pos = [4, 4]
      queen = Queen.new(pos)
      board = Board.new
      board.set_cell(queen)
      res = board.cell_empty?(pos)
      expect(res).to be false
    end
  end

  describe "#create_board" do
    xit "creates board with width and height" do
    end
  end
end
