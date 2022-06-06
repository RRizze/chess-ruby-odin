class Board

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

  SYMBOLS = {
    #cell: "\U+1FB9x"
    cell: "  ",
    king: "♚ ",
  }

  def initialize
    @board = Array.new(64, "  ")
  end

  def colorize(str, fg, bg)
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
          cell_str += set_color_bg(@board[pos], :blue)
        else
          cell_str += set_color_bg(@board[pos], :white)
        end
      end
      cell_str += "\n"
    end
    print cell_str
  end
end
