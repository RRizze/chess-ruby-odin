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

  describe "#cell_empty?" do
    it "returns true if cell is empty" do
      pos = [4, 4]
      board = Board.new
      res = board.cell_is_empty?(pos)
      expect(res).to be true
    end

    it "returns false if cell is not empty" do
      pos = [4, 4]
      queen = Queen.new(:black)
      board = Board.new
      board.set_figure(queen, pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be false
    end
  end

  describe "#set_figure" do
    it "changes game symbol if move is legal" do
      pos = [4, 4]
      queen = Queen.new(:black)
      board = Board.new
      board.set_figure(queen, pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be false
    end
  end

  context "Movement" do

    describe "movement_to_arr" do
      it "converts str to array of arrays and returns the last one" do
        movement = "d5-d4"
        #["d5", "d4"]
        #d5 > [3,3] d4 -> [3,4]
        board = Board.new
        res = board.movement_to_arr(movement)
        expect(res).to eq([[3,3], [4,3]])
      end
    end

    describe "#neighbors" do
      it "returns neighbors for current node" do
        board = Board.new
        # black figure
        figure = board.board[board.get_index([1, 0])].content
        # first move
        res = board.neighbors([1, 0], figure)
        expect(res).to eq([[2, 0], [3, 0]])
      end
    end

    describe "#moves" do
      it "returns available moves for particular figure" do
        board = Board.new
        move = [[1, 0], [2, 0]]
        valid_moves = board.moves(move)
        expect(valid_moves).to eq([[[1, 0], [2, 0]], [[1, 0], [3, 0]]])
      end
    end

    describe "#valid_moves" do
      # valid_moves depends on moves
    end

    describe "#in_bounds?" do
      xit "returns true if figure in the bounds" do
        pos = [4, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be true
      end

      xit "returns false if figure not in the bounds" do
        pos = [-1, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be false
      end
    end


    describe "#move" do
      xit "place figure on the target cell if is empty" do
        path = "d2-d3"
        board = Board.new

        # set figure on the board
        pos_arr = board.move_to_pos(path)

        # move figure
        board.move(path)

        index = board.get_index(pos_arr[1])

        res = board.cell_empty?(pos_arr[1])
        expect(res).to be false
      end
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
