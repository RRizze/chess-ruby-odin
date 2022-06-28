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
      board.remove_piece(pos)
      res = board.cell_is_empty?(pos)
      expect(res).to be true
    end
  end

  context "Movement" do

    describe "movement_to_arr" do
      xit "converts str to array of arrays and returns the last one" do
        movement = "d5-d4"
        #["d5", "d4"]
        #d5 > [3,3] d4 -> [3,4]
        board = Board.new
        res = board.movement_to_arr(movement)
        expect(res).to eq([[3,3], [4,3]])
      end

      xit "converts str to array of arrays and returns the last one" do
        movement = "a8-a5"
        #["d5", "d4"]
        #d5 > [3,3] d4 -> [3,4]
        board = Board.new
        res = board.movement_to_arr(movement)
        expect(res).to eq([[0,0], [3,0]])
      end
    end

    describe "#neighbors" do
      xit "returns neighbors for current node" do
        board = Board.new
        # black piece
        piece = board.board[board.get_index([1, 0])].content
        # first move
        from = [1, 0]
        to = [3, 0]
        res = board.neighbors(from, to, piece, board.get_direction(from, to))
        expect(res).to eq([[2, 0], [3, 0]])
      end

      xit "returns neighbors for pawn wxith diag moves" do
        board = Board.new
        player_w = Player.new(:whxite)
        player_b = Player.new(:black)
        board.move("b2-b4", player_w)
        board.move("a7-a5", player_b)
        #res = board.move("b4-a5", player_w)
        move = [[4, 1], [3, 0]]
        piece = board.board[board.get_index(move[0])].content
        dir = board.get_direction(move[0], move[1])
        res = board.neighbors(move[0], move[1], piece, dir)

        expect(res).to eq([[3, 0]])
      end

      xit "returns neighbors for knight" do
        board = Board.new
        # black piece
        knight = board.board[board.get_index([7, 1])].content
        # first move
        from = [7, 1]
        to = [6, 3]
        dir = board.get_direction(from, to)
        neighbors = board.neighbors(from, to, knight, dir)
        res = neighbors.include?([6,3]) and neighbors.include?([5,2])
        expect(res).to be true
      end
    end

    describe "#valid_moves" do
      xit "returns available moves for particular piece" do
        board = Board.new
        move = [[1, 0], [3, 0]]
        valid_moves = board.valid_moves(move)
        expect(valid_moves).to eq([[[1, 0], [2, 0]], [[1, 0], [3, 0]]])
      end

      xit "returns empty array for incorrect move for particular piece" do
        board = Board.new
        move = [[7, 1], [6, 3]]
        valid_moves = board.valid_moves(move)
        expect(valid_moves).to eq([])
      end

      xit "returns array for the correct pawn move" do
        board = Board.new
        player_w = Player.new(:whxite)
        player_b = Player.new(:black)
        board.move("b2-b4", player_w)
        board.move("a7-a5", player_b)
        move = [[4, 1], [3, 0]]
        #res = board.move("b4-a5", player_w)
        res = board.valid_moves(move)
        expect(res).to eq([[[4, 1], [3, 0]]])
      end

      xit "returns array for the correct rook move" do
        board = Board.new
        player_w = Player.new(:whxite)
        player_b = Player.new(:black)
        board.move("b2-b4", player_w)
        board.move("a7-a5", player_b)
        board.move("b4-a5", player_w)
        move = [[0, 0], [3,0]]
        res = board.valid_moves(move)
        #res = board.move("a8-a5", player_b)
        expect(res).to eq([[[0, 0], [1, 0]], [[1, 0], [2, 0]], [[2, 0], [3,0]]])
      end
    end

    describe "#in_bounds?" do
      xit "returns true if piece in the bounds" do
        pos = [4, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be true
      end

      xit "returns false if piece not in the bounds" do
        pos = [-1, 4]
        board = Board.new
        res = board.in_bounds?(pos)
        expect(res).to be false
      end
    end

    describe "#same_colors" do
      xit "returns true if pieces have same colors" do
        board = Board.new
        move = "b1-d2"
        from, to = board.movement_to_arr(move)
        res = board.same_colors?(from, to)
        expect(res).to be true
      end
    end

    context "Movement" do
      describe "get_unxit_vector" do
        xit "returns unxit vector" do
          board = Board.new
          from = [5, 2]
          res = board.get_unxit_vector(from)
          expect(res).to eq([1, 1])
        end
      end

      describe "#get_direction" do
        xit "returns direction vector" do
          board = Board.new
          from = [5, 2]
          to = [3,0]
          res = board.get_direction(from, to)
          expect(res).to eq([-1, -1])
        end
      end

      describe "#move" do
        xit "returns true AND place piece on the target cell if is empty" do
          path = "c2-c4"
          board = Board.new
          player = Player.new(:whxite)
          res = board.move(path, player)

          expect(res).to be true
        end

        xit "returns FALSE and should do nothing wxith empty cells" do
          path = "d3-d4"
          board = Board.new
          player = Player.new(:whxite)
          res = board.move(path, player)

          expect(res).to be false
        end
      end

      describe "#passant_capture?" do
        xit "returns true if pawn was captured by other one" do
          board = Board.new
          from = [3, 1] #b5
          to = [2, 0] #a6
          player_b = Player.new(:black)
          player_w = Player.new(:whxite)

          board.move("c2-c4", player_w)
          board.move("h7-h6", player_b)

          board.move("c4-c5", player_w)
          board.move("b7-b5", player_b)

          #board.move("c5-b6", player_w)
          res = board.passant_capture?(from, to)
          expect(res).to be true
        end

        xit "clears the cell if pawn jumped" do
          board = Board.new
          pos = [3, 1] #b5
          player_b = Player.new(:black)
          player_w = Player.new(:whxite)

          board.move("c2-c4", player_w)
          board.move("h7-h6", player_b)

          board.move("c4-c5", player_w)
          board.move("b7-b5", player_b)

          board.move("c5-b6", player_w)
          res = board.cell_is_empty?(pos)
          expect(res).to be true
        end
      end

    end

    context "check and mate" do
      describe "#king_in_check?" do
        xit "returns false if king king in not check" do
          board = Board.new
          res = board.king_in_check?
        end
      end

      describe "#checkmate?" do
        xit "returns 'checkmate' if checkmate" do
          board = Board.new
          "e2-e3"
          "d7-d6"
          "f1-b5"
          color = :black
          res = board.checkmate?(color)
          expect(res).to eq("checkmate")
        end
      end
    end

  end

  context "AI" do
  end
end
