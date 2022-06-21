require "set"
require_relative "cell"
require_relative "pawn"
require_relative "knight"
require_relative "bishop"
require_relative "rook"
require_relative "queen"
require_relative "king"
require_relative "color"

class Board
  include Color
  attr_accessor :board

  LABELS = {
    letters: ["a", "b", "c", "d", "e", "f", "g", "h"],
    nums: ["8", "7", "6", "5", "4", "3", "2", "1"],
  }

  def initialize
    @rows = 8
    @columns = 8
    @board = create_board(@rows, @columns)
    init()
  end

  def create_board(w, h)
    board = []
    (0..7).each do |row|
      (0..7).each do |col|
        content = "  "
        # white == blue for my colorshcheme.
        if (row+col) % 2 == 0
          content = colorize(content, :blue, :blue)
          board.push(Cell.new([row, col], content, :blue))
        # black == white for my colorshcheme.
        else
          content = colorize(content, :white, :white)
          board.push(Cell.new([row, col], content, :white))
        end
      end
    end
    board
  end

  def set_piece(piece, pos)
    index = get_index(pos)
    bg_color = @board[index].color
    # update bg color
    piece.set_token_bg(bg_color)

    @board[index].content = piece
  end

  def print_board
    cell_str = ""
    puts " " + LABELS[:letters].join(" ")
    (0..7).each do |row|
      cell_str += "#{@rows-row}"
      (0..7).each do |col|
        pos = get_index([row, col])

        if cell_is_empty?([row, col])
          cell_str += @board[pos].content
        else
          cell_str += @board[pos].content.token_bg
        end
      end
      cell_str += "#{row+1}"
      cell_str += "\n"
    end
    print cell_str
    puts " " + LABELS[:letters].join(" ")
  end

  def cell_is_empty?(pos)
    index = get_index(pos)
    @board[index].content.is_a?(String)
  end

  def get_index(pos)
    pos[0] * @columns + pos[1]
  end

  def movement_to_arr(movement)
    regexp = Regexp.new(/([a-h]{1,1}[1-8]{1,1})-([a-h]{1,1}[1-8]{1,1})/)
    match = movement.match?(regexp)

    if !match
      return false
    end

    movement_arr = movement.split("-")
    pos = movement_arr.map do |move|
      row = LABELS[:letters].index(move[0])
      col = LABELS[:nums].index(move[1])
      [col, row]
    end
    pos
  end

  def valid_moves(move)
    from = move[0]
    to = move[1]
    cell_from = @board[get_index(from)]
    cell_to = @board[get_index(to)]

    frontier = []
    frontier.push(from)
    visited = Set.new()
    came_from = {} # a->b came_from[b] = a
    # if I will need path
    came_from[from] = nil

    piece = cell_from.content
    direction = get_direction(from, to)

    if same_colors?(from, to)
      return []
    end

    until frontier.empty?
      current = frontier.shift

      if current == to
        break;
      end

      if !visited.include?(current)
        visited.add(current)
        # process with current
      end

      neighbors = neighbors(current, to, piece, direction)
      #p "neighbors for #{move[0]}, #{move[1]}", neighbors

      if neighbors.include?(to)
        for next_pos in neighbors
          came_from[next_pos] = current
        end
        break
      end

      for next_pos in neighbors
        if !visited.include?(next_pos)
          frontier.push(next_pos)
          came_from[next_pos] = current
        end
      end
    end
    #p came_from

    res = []
    for to, from in came_from
      if !to.nil? && !from.nil?
        res.push([from, to])
      end
    end
    #p "res: #{res[0]} ##{res[1]}"
    #p res

    return res
  end

  def neighbors(from, to, piece, direction)
    result = []
    dirs = nil

    if piece.is_a?(Pawn)
      if !cell_is_empty?(to) or passant_capture?(from, to)
        dirs = piece.get_directions(true)
      else
        dirs = piece.get_directions(false)
      end
    else
      dirs = piece.get_directions
    end

    dirs = dirs.select { |dir| get_unit_vector(dir) == direction }
    #p "dirs from: #{from}, to #{to}", dirs 

    for dir in dirs
      new_pos = [
        from[0] + dir[0],
        from[1] + dir[1]
      ]

      if new_pos == to
        result.push(new_pos)
        return result
      end

      # omfg
      if in_bounds?(new_pos)
        if cell_is_empty?(new_pos)
          result.push(new_pos)
        else
          if !same_color?(piece, @board[get_index(new_pos)].content)
            result.push(new_pos)
          end
        end
      end
    end

    return result
  end

  def in_bounds?(pos)
    if (pos[0] >= 0 and pos[0] < @rows and
        pos[1] >= 0 and pos[1] < @columns)
      return true
    else
      return false
    end
  end

  def same_color?(figure1, figure2)
    return figure1.color == figure2.color
  end

  def same_colors?(from, to)
    from_idx = get_index(from)
    to_idx = get_index(to)

    if !cell_is_empty?(to) && !cell_is_empty?(from)
      if @board[from_idx].content.color == @board[to_idx].content.color
        return true
      else
        return false
      end
    end
  end

  def passant_capture?(from, to)
    # color doesn't matter

    from_idx = get_index(from)
    to_idx = get_index(to)
    piece_from = @board[from_idx].content

    pos_left = [from[0],  (from[1] - 1)]
    pos_right = [from[0], (from[1] + 1)]
    cell_left = @board[get_index(pos_left)]
    cell_right = @board[get_index(pos_right)]
    #p "pawn is jumped? #{cell_left.content.jumped?}"

    if cell_left.content.is_a?(Pawn) and cell_left.content.jumped?
      cell_left.content = colorize("  ", :no_color, cell_left.color)
      return true
    elsif cell_right.content.is_a?(Pawn) and cell_right.content.jumped?
      cell_right.content = colorize("  ", :no_color, cell_right.color)
      return true
    else
      return false
    end
  end

  def move(movement, player)
    move_arr = movement_to_arr(movement)

    return false if !move_arr
    from = move_arr[0]
    to = move_arr[1]

    if cell_is_empty?(from)
      return false
    end

    # check for correct player color
    piece_color = @board[get_index(from)].content.color

    if (player[:color] == :white and piece_color == :black or
       player[:color] == :black and piece_color == :no_color)
      return false
    end

    # check valid moves for piece
    valid_moves = valid_moves(move_arr)
    #p "valid_moves for #{from}, to: #{to}", valid_moves

    if valid_moves.length == 0
      return false
    end

    cell_from = @board[get_index(from)]
    piece = cell_from.content

    if piece.is_a?(Pawn) and (to[0] - from[0]).abs == 2 and piece.moves == 0
      piece.jump = true
      piece.moves += 1
    end

    # clear cell
    #if passant_capture?(from, to)

    cell_from.content = colorize("  ", :no_color, cell_from.color)
    set_piece(piece, to)
    if piece.is_a?(Pawn)
      piece.moves += 1
      return true
    end
    return true

  end

  def get_unit_vector(pos)
    x = pos[0] == 0 ? 0 : pos[0] / (pos[0]).abs
    y = pos[1] == 0 ? 0 : pos[1] / (pos[1]).abs

    return [x, y]
  end

  def get_direction(from, to)
    new_pos = [
      to[0] - from[0],
      to[1] - from[1]
    ]

    return get_unit_vector(new_pos)
  end

  private

  def init
    # pawns
    (0..7).each do |col|
      p_black = Pawn.new(:black)
      set_piece(p_black, [1, col])
    end

    (0..7).each do |col|
      p_white = Pawn.new(:no_color)
      set_piece(p_white, [6, col])
    end

    # rook
    r1_black = Rook.new(:black)
    r2_black = Rook.new(:black)
    set_piece(r1_black, [0, 0])
    set_piece(r2_black, [0, 7])

    # knight
    k1_black = Knight.new(:black)
    k2_black = Knight.new(:black)
    set_piece(k1_black, [0, 1])
    set_piece(k2_black, [0, 6])

    # bishop
    b1_black = Bishop.new(:black)
    b2_black = Bishop.new(:black)
    set_piece(b1_black, [0, 2])
    set_piece(b2_black, [0, 5])

    # queen
    q_black = Queen.new(:black)
    set_piece(q_black, [0, 3])

    # king
    ki_black = King.new(:black)
    set_piece(ki_black, [0, 4])

    # white
    # rook
    r1_white = Rook.new(:no_color)
    r2_white = Rook.new(:no_color)
    set_piece(r1_white, [7, 0])
    set_piece(r2_white, [7, 7])

    # knight
    k1_white = Knight.new(:no_color)
    k2_white = Knight.new(:no_color)
    set_piece(k1_white, [7, 1])
    set_piece(k2_white, [7, 6])

    # bishop
    b1_white = Bishop.new(:no_color)
    b2_white = Bishop.new(:no_color)
    set_piece(b1_white, [7, 2])
    set_piece(b2_white, [7, 5])

    # queen
    q_white = Queen.new(:no_color)
    set_piece(q_white, [7, 3])

    # king
    ki_white = King.new(:no_color)
    set_piece(ki_white, [7, 4])
  end
end
