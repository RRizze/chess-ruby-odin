require "./lib/board.rb"
require "./lib/queen.rb"
require "./lib/pawn.rb"
require "./lib/player.rb"

describe Board do

  describe "#create_board" do
    it "creates board wxith width and height" do
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
      pos = [0, 0]
      board = Board.new
      board.fill()
      res = board.cell_is_empty?(pos)
      expect(res).to be false
    end
  end

  describe "#set_piece" do
    it "changes game symbol if move is legal" do
      pos = [4, 4]
      board = Board.new
      queen = Queen.new(:black, pos, board)
      board.set_piece(queen, pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be false
    end
  end

  describe "#remove_piece" do
    it "remove piece at the position" do
      pos = [0, 0]
      board = Board.new
      board.fill()
      board.remove_piece(pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be true
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

      it "converts str to array of arrays and returns the last one" do
        movement = "a8-a5"
        #["d5", "d4"]
        #d5 > [3,3] d4 -> [3,4]
        board = Board.new
        res = board.movement_to_arr(movement)
        expect(res).to eq([[0,0], [3,0]])
      end
    end

    describe "#in_bounds?" do
      it "returns true if piece in the bounds" do
        board = Board.new
        pos = [4, 4]
        res = board.in_bounds?(pos)
        expect(res).to be true
      end

      it "returns false if piece not in the bounds" do
        board = Board.new
        pos = [-1, 4]
        res = board.in_bounds?(pos)
        expect(res).to be false
      end
    end

    describe "#same_colors" do
      it "returns true if pieces have same colors" do
        board = Board.new
        board.fill()
        move = "b1-d2"
        from, to = board.movement_to_arr(move)
        res = board.same_colors?(from, to)
        expect(res).to be true
      end
    end

    context "Movement" do

      describe "#move" do
        it "returns true AND place piece on the target cell if is empty" do
          path = "c2-c4"
          board = Board.new
          board.fill()
          player = Player.new(:white)
          res = board.move(path, player)

          expect(res).to be true
        end

        it "returns FALSE and should do nothing wxith empty cells" do
          path = "d3-d4"
          board = Board.new
          player = Player.new(:white)
          res = board.move(path, player)

          expect(res).to be false
        end
      end

    end

  end

  context "AI" do
  end
end
