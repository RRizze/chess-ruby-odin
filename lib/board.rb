require_relative "cell"

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

  def initialize
    @rows = 7
    @columns = 7
    @board = create_board(@rows, @columns)
  end

  def create_board(w, h)
    board = []
    (0..7).each do |row|
      (0..7).each do |col|
        board.push(Cell.new([row, col], "  "))
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
    (0..7).each do |row|
      (0..7).each do |col|
        pos = row * 7 + col
        if pos % 2 == 0
          cell_str += set_color_bg(@board[pos].content, :blue)
        else
          cell_str += set_color_bg(@board[pos].content, :white)
        end
      end
      cell_str += "\n"
    end
    print cell_str
  end

  def set_cell(figure)
    pos = figure.position[0] * 7 + figure.position[1]
    @board[pos].content = figure.game_symbol
  end

  def cell_empty?(pos)
    @board[pos[0] * @columns + pos[1]].content == "  "
  end

  # bfs and neighbors
  def neighbors(figure)
    # array of what? [],[] or Cells or Figures
    neighbors = []

    figure.dirs.each do |dir|
      pos = figure.position #[x, y]
      # check boundaries
      if pos[0] >= 0 and pos[0] <= 7 and pos[1] >= 0 and pos[1] <=7
        # add to vectors
        new_pos = [
          dir[0] + pos[0],
          dir[1] + pos[1]
        ]
        #neighbors.push(
      end
    end
  end

  def bfs(figure)
    queue = [figure]
    visited = Set.new
    visited.add(figure)

    while !queue.empty?
      #current = queue.shif
    end
  end

end
