require "./lib/board.rb"
require "./lib/queen.rb"

describe Board do

  describe "#create_board" do
    it "creates board with width and height" do
      board = Board.new
      expect(board.board.length).to eq(64)
    end
  end

  describe "#get_index" do
    it "returns index from pos[x,y]" do
      board = Board.new
      pos = [3,3]
      index = board.get_index(pos)
      expect(index).to eq(27)
    end
  end

  describe "#set_figure" do
    it "changes game symbol if move is legal" do
      pos = [4, 4]
      queen = Queen.new(:black)
      board = Board.new
      board.set_figure(queen, pos)
      index = board.get_index(pos)
      res = board.board[index].content.include?(queen.token)
      expect(res).to be true
    end
  end

  describe "#cell_empty?" do
    it "returns true if cell is empty" do
      pos = [4, 4]
      board = Board.new
      res = board.cell_empty?(pos)
      expect(res).to be true
    end

    it "returns flase if cell is not empty" do
      pos = [4, 4]
      queen = Queen.new(:black)
      board = Board.new
      board.set_figure(queen, pos)
      res = board.cell_empty?(pos)
      expect(res).to be false
    end
  end


  describe "#in_bounds?" do
    it "returns true if figure in the bounds" do
      pos = [4, 4]
      board = Board.new
      res = board.in_bounds?(pos)
      expect(res).to be true
    end

    it "returns false if figure not in the bounds" do
      pos = [-1, 4]
      board = Board.new
      res = board.in_bounds?(pos)
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
