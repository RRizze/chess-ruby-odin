require "./lib/board.rb"
require "./lib/queen.rb"

describe Board do

  describe "#create_board" do
    it "creates board with width and height" do
      board = Board.new
      expect(board.board.length).to eq(64)
    end
  end

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

  describe "#set_figure" do
    xit "changes game symbol if move is legal" do
      pos = [4, 4]
      queen = Queen.new(pos)
      board = Board.new
      board.set_figure(queen)
      # change game_symbol for...  .get_symbol, .sign, .to_s, .to_str
      expect(board.board[pos[0] * 7 + pos[1]].content).to be(queen.game_symbol)
    end
  end

  describe "#cell_free?" do
    xit "returns true if cell is empty" do
      pos = [4, 4]
      board = Board.new
      res = board.cell_empty?(pos)
      expect(res).to be true
    end

    xit "returns flase if cell is not empty" do
      pos = [4, 4]
      queen = Queen.new(pos)
      board = Board.new
      board.set_figure(queen)
      res = board.cell_empty?(pos)
      expect(res).to be false
    end
  end


  describe "#in_bounds?" do
    xit "returns true if figure in the bounds" do
      pos = [4, 4]
      queen = Queen.new(pos)
      board = Board.new
      res = board.in_bounds?(queen.position)
      expect(res).to be true
    end

    xit "returns false if figure not in the bounds" do
      pos = [-1, 4]
      queen = Queen.new
      board = Board.new
      res = board.in_bounds?(queen.position)
      expect(res).to be false
    end
  end

  context "AI" do

    describe "#neighbors" do
      xit "returns arr of neighbors" do
        pos = [4, 4]
        board = Board.new
        queen = Queen.new(pos)
        neighbors = board.neighbors(queen)
        expect(neighbors.length).to eq(8)
      end
    end
  end

end
