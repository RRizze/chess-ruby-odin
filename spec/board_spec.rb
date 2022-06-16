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
      board.set_piece(queen, pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be false
    end
  end

  describe "#set_piece" do
    it "changes game symbol if move is legal" do
      pos = [4, 4]
      queen = Queen.new(:black)
      board = Board.new
      board.set_piece(queen, pos)
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
        # black piece
        piece = board.board[board.get_index([1, 0])].content
        # first move
        res = board.neighbors([1, 0], [3, 0], piece)
        expect(res).to eq([[2, 0], [3, 0]])
      end

      it "returns neighbors for knight" do
        board = Board.new
        # black piece
        knight = board.board[board.get_index([7, 1])].content
        # first move
        neighbors = board.neighbors([7, 1], [6, 3], knight)
        res = neighbors.include?([5,0]) and neighbors.include?([5,2])
        expect(res).to be true
      end
    end

    describe "#valid_moves" do
      it "returns available moves for particular piece" do
        board = Board.new
        move = [[1, 0], [2, 0]]
        valid_moves = board.valid_moves(move)
        expect(valid_moves).to eq([[[1, 0], [2, 0]]])
      end

      it "returns empty array for incorrect move for particular piece" do
        board = Board.new
        move = [[7, 1], [6, 3]]
        valid_moves = board.valid_moves(move)
        expect(valid_moves).to eq([])
      end
    end

    describe "#in_bounds?" do
      it "returns true if piece in the bounds" do
        pos = [4, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be true
      end

      it "returns false if piece not in the bounds" do
        pos = [-1, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be false
      end
    end

    describe "#same_colors" do
      it "returns true if pieces have same colors" do
        board = Board.new
        move = "b1-d2"
        from, to = board.movement_to_arr(move)
        res = board.same_colors?(from, to)
        expect(res).to be true
      end
    end

    context "Movement" do

      describe "#move" do
        it "returns true AND place piece on the target cell if is empty" do
          path = "e2-e3"
          board = Board.new
          res = board.move(path)

          expect(res).to be true
        end

        it "returns FALSE and should do nothing with empty cells" do
          path = "d3-d4"
          board = Board.new
          res = board.move(path)

          expect(res).to be false
        end
      end

    end
  end

  context "AI" do
  end
end
