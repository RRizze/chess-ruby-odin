require_relative "piece"
require_relative "rook"
require_relative "queen"
require_relative "bishop"

class King < Piece

  def initialize(color, position, board)
    super(color, position, board)
    @token = "♚ "
    @directions = [
      [-1, 0], [1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [1, -1], [-1, -1]
    ]
  end

  def get_fen
    (@color == :black) ? "k" : "K"
  end

  def line_is_danger?(pos, add_vector)
    # pawn check
    pawn_pos1 = 0
    pawn_pos2 = 0

    if @color == :black
      pawn_pos1 = [pos[0] + 1, pos[1] - 1]
      pawn_pos2 = [pos[0] + 1, pos[1] + 1]
    else
      pawn_pos1 = [pos[0] - 1, pos[1] - 1]
      pawn_pos2 = [pos[0] - 1, pos[1] + 1]
    end

    possible_pawn1 = @board.get_piece(pawn_pos1)
    possible_pawn2 = @board.get_piece(pawn_pos2)

    if possible_pawn1
      if possible_pawn1.is_a?(Pawn) and possible_pawn1.color != @color
        return true
      end
    end

    if possible_pawn2
      if possible_pawn2.is_a?(Pawn) and possible_pawn2.color != @color
        return true
      end
    end

    line_type = (add_vector[0].abs == 1 and
      add_vector[1].abs == 1) ? :diagonal : :non_diagonal

    if line_type == :non_diagonal
      start_pos = sum_vec(pos, add_vector)

      while (start_pos[0] >= 0 and start_pos[0] < 8 and
          start_pos[1] >= 0 and start_pos[1] < 8)
        
        if @board.cell_is_empty?(start_pos)
          start_pos = sum_vec(start_pos, add_vector)
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break
          elsif piece.is_a?(Rook) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos = sum_vec(start_pos, add_vector)
      end
    else
      #diagonal
      start_pos = sum_vec(pos, add_vector)
      while (start_pos[0] >= 0 and start_pos[0] < 8 and
          start_pos[1] >= 0 and start_pos[1] < 8)
        
        if @board.cell_is_empty?(start_pos)
          start_pos = sum_vec(start_pos, add_vector)
          next
        else
          piece = @board.get_piece(start_pos)

          if piece.color == @color
            break
          elsif piece.is_a?(Bishop) or piece.is_a?(Queen)
            return true
          end
        end
        start_pos = sum_vec(start_pos, add_vector)
      end
    end
    return false
  end

  def checkmate?
    danger_dirs = []
    @directions.each do |dir|
      danger_dirs.push << dir if line_is_danger?(@position, dir)
    end

    # if king is under attack
    if danger_dirs.length > 0
      # find any safe cells
      possible_free_dirs = (Set.new(danger_dirs) ^ Set.new(@directions)).to_a
      possible_free_dirs = possible_free_dirs.select do |dir|
        pos = sum_vec(@position, dir)
        if @board.in_bounds?(pos) and @board.cell_is_empty?(pos)
          dir
        end
      end

      safe_cells = []
      possible_free_dirs.each do |possible_dir|
        pos = sum_vec(@position, possible_dir)
        count_dangers = 0
        @directions.each do |add_vec|
          if line_is_danger?(pos, add_vec)
            count_dangers += 1
          end
        end
        if count_dangers == 0
          safe_cells << pos
        end
      end

      if safe_cells.length > 0
        return :check
      else
        # find friends figure for protect their king
        pos_danger = 0
        possible_def = 0
        if @color == :black
          danger_dirs.each do |dir|
            pos_danger = sum_vec(@position, dir)
            @board.blacks.each do |bl|
              if @board.cell_is_empty?(pos_danger)
                if bl.can_move?(pos_danger)
                  possible_def += 1
                end
              end
            end
          end
        else
          danger_dirs.each do |dir|
            pos_danger = add_vector(@position, dir)
            @board.whites.each do |white|
              if @board.cell_is_empty?(pos_danger)
                if white.can_move?(pos_danger)
                  possible_def += 1
                end
              end
            end
          end
        end
        if possible_def == 0
          return :checkmate
        else
          return :check
        end
      end
    else
      return false
    end

  end

  def can_move?(destination)
    # false if piece at the destination has same color
    possible_piece = @board.get_piece(destination)

    if possible_piece
      if possible_piece.color == @color
        return false
      end
    end

    direction = get_direction(@position, destination)

    # false if length of move is more than 1 along Rows
    if (destination[0] - @position[0]).abs > 1
      return false
    end

    # false if dir is incorrect
    if !@directions.include?(direction)
      return false
    end

    diff_cols = destination[1] - @position[1]

    if diff_cols.abs == 2 and @did_move
      return false
    end

    if direction == [0, -1] and (diff_cols).abs == 2
      if @color == :black and !@board.castling.include?("q")
        return false
      elsif @color == :black and @board.castling.include?("q")
        @board.castling = "KQ"
      end

      if @color == :no_color and !@board.castling.include?("Q")
        return false
      elsif @color == :no_color and @board.castling.include?("Q")
        @board.castling = "kq"
      end

      empty_p1_pos = [@position[0], @position[1] - 1]
      empty_p2_pos = [@position[0], @position[1] - 2]
      empty_p3_pos = [@position[0], @position[1] - 3]

      possible_p1 = @board.cell_is_empty?(empty_p1_pos)
      possible_p2 = @board.cell_is_empty?(empty_p2_pos)
      possible_p3 = @board.cell_is_empty?(empty_p3_pos)

      rook_pos = (@color == :black) ? [0, 0] : [7, 0]
      possible_rook = @board.get_piece(rook_pos)

      if !possible_rook
        return false
      end

      if !possible_p1 or !possible_p2 or !possible_p3 or possible_rook.did_move
        return false
      end

    # short castling
    elsif direction == [0, 1] and (diff_cols).abs == 2
      if @color == :black and !@board.castling.include?("k")
        return false
      end

      if @color == :no_color and !@board.castling.include?("K")
        return false
      end

      empty_p1_pos = [@position[0], @position[1] - 1]
      empty_p2_pos = [@position[0], @position[1] - 2]

      possible_p1 = @board.cell_is_empty?(empty_p1_pos)
      possible_p2 = @board.cell_is_empty?(empty_p2_pos)

      rook_pos = @color == :black ? [0, 7] : [7, 7]
      possible_rook = @board.get_piece(rook_pos)

      if !possible_rook
        return false
      end

      if !possible_p1 or !possible_p2 or possible_rook.did_move
        return false
      end
    end

    # can't move to the danger zone
    return !is_danger?(destination)
  end

  def is_danger?(to)
    from = @position
    direction = get_direction(from, to)

    case direction
    # right and left direction
    when [0, 1], [0, -1]

      return true if line_is_danger?(to, [1, 0])

      return true if line_is_danger?(to, [-1, 0])

    # top and bot
    when [1, 0], [-1, 0]

      return true if line_is_danger?(to, [0, 1])

      return true if line_is_danger?(to, [0, -1])

    # top-right and bottom-left
    when [-1, 1], [1, -1]
      # check top-left part of diagonal
      return true if line_is_danger?(to, [-1, -1])

      # check bottom-right part of diagonal
      return true if line_is_danger?(to, [1, 1])

    # bottom-right and top-left
    when [1, 1], [-1, -1]
      # check top-right part of diagonal
      return true if line_is_danger?(to, [-1, 1])

      # check bottom-left part of diagonal
      return true if line_is_danger?(to, [1, -1])
    end

    return false
  end
end
