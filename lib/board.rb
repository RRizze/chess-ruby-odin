require "set"
require_relative "cell"
require_relative "pawn"
require_relative "knight"
require_relative "bishop"
require_relative "rook"
require_relative "queen"
require_relative "king"

class Board
  attr_accessor :board

  ESC_CLR = "\e[0m"
  COLORS = {
    fg: {
      # foreground colors
      black: "30",
      red: "31",
      green: "32",
      blue: "34",
      white: "37",
    },
    bg: {
      # background colors
      black: "40",
      red: "41",
      green: "42",
      blue: "44",
      white: "47",
    },
    no_color: -> (str) { "\e[#{str}#{ESC_CLR}"},
  }

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
        if (row+col) % 2 == 0
          color = :blue
          content = set_color_bg(content, :blue)
          board.push(Cell.new([row, col], content, color))
        else
          color = :white
          content = set_color_bg(content, :white)
          board.push(Cell.new([row, col], content, color))
        end
      end
    end
    board
  end


  def colorize(str, fg, bg)
    str = "" if str.nil?
    "\e[#{COLORS[:fg][fg]};#{COLORS[:bg][bg]}m#{str}#{ESC_CLR}"
  end

  def set_color_fg(str, fg)
    "\e[#{COLORS[:fg][fg]}m#{str}#{ESC_CLR}"
  end

  def set_color_bg(str, bg)
    "\e[#{COLORS[:bg][bg]}m#{str}#{ESC_CLR}"
  end

  def set_color(str, fg, bg)
    if COLORS[:fg].has_key?(fg) && COLORS[:bg].has_key?(bg)
      colorize(str, fg, bg)
    else
      COLORS[:no_color].call(str)
    end
  end

  def print_board
    cell_str = ""
    puts " " + LABELS[:letters].join(" ")
    (0..7).each do |row|
      cell_str += "#{@rows-row}"
      (0..7).each do |col|
        pos = row * @columns + col
        if @board[pos].content.is_a?(String)
          cell_str += @board[pos].content
        else
          cell_str += @board[pos].content.token
        end
      end
      cell_str += "#{row+1}"
      cell_str += "\n"
    end
    print cell_str
    puts " " + LABELS[:letters].join(" ")
  end

  def set_figure(figure, pos)
    index = get_index(pos)
    cell = @board[index]
    token = colorize(figure.token, figure.color, cell.color)
    figure.set_token(token)
    cell.content = figure
  end

  def cell_empty?(pos)
    index = get_index(pos)
    content = @board[index].content
    if content.is_a?(String)
      return true
    elsif content.is_a?(Figure)
      return false
    end
  end

  # bfs and neighbors
  def in_bounds?(position)
    return (position[0] >= 0 and position[0] <= @rows and
          position[1] >= 0 and position[1] <= @columns)
  end

  def get_index(pos)
    pos[0] * @columns + pos[1]
  end

  def move_to_pos(move)
    move_arr = move.split("-")
    move_arr.map do |move|
      row = LABELS[:letters].index(move[0])
      col = LABELS[:nums].index(move[1])
      [col, row]
    end
  end

  def move(figure, move)
    # check if position is valid
    # check if cell is empty
    # check if there's a figure it's another different color
    from, to = move_to_pos(move)
    # get figure from board?
    # change create board and display.
    # content = "  " or figure.token
    set_figure(figure, to)
  end

  private

  def init
    # pawns
    (0..7).each do |col|
      p_black = Pawn.new(:black)
      set_figure(p_black, [1, col])
    end

    (0..7).each do |col|
      p_white = Pawn.new(:no_color)
      set_figure(p_white, [6, col])
    end

    # rook
    r1_black = Rook.new(:black)
    set_figure(r1_black, [0,0])
    r2_black = Rook.new(:black)
    set_figure(r2_black, [0,7])
    # knigh
    k1_black = Knight.new(:black)
    set_figure(k1_black, [0,1])
    k2_black = Knight.new(:black)
    set_figure(k2_black, [0,6])
    # bishop
    b1_black = Bishop.new(:black)
    set_figure(b1_black, [0,2])
    b2_black = Bishop.new(:black)
    set_figure(b2_black, [0,5])
    # queen
    q_black = Queen.new(:black)
    set_figure(q_black, [0,3])
    # king
    ki_black = King.new(:black)
    set_figure(ki_black, [0,4])

    # rook
    r1_white = Rook.new(:no_color)
    set_figure(r1_white, [7,0])
    r2_white = Rook.new(:no_color)
    set_figure(r2_white, [7,7])
    # knigh
    k1_white = Knight.new(:no_color)
    set_figure(k1_white, [7,1])
    k2_white = Knight.new(:no_color)
    set_figure(k2_white, [7,6])
    # bishop
    b1_white = Bishop.new(:no_color)
    set_figure(b1_white, [7,2])
    b2_white = Bishop.new(:no_color)
    set_figure(b2_white, [7,5])
    # queen
    q_white = Queen.new(:no_color)
    set_figure(q_white, [7,3])
    # king
    ki_white = King.new(:no_color)
    set_figure(ki_white, [7,4])
  end

end
