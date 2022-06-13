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


  def set_figure(figure, pos)
    index = get_index(pos)
    bg_color = @board[index].color
    figure.set_token_bg(bg_color)

    @board[index].content = figure
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
    movement_arr = movement.split("-")
    pos = movement_arr.map do |move|
      row = LABELS[:letters].index(move[0])
      col = LABELS[:nums].index(move[1])
      [col, row]
    end
    pos
  end

  def move(movement)
    pos = movement_to_arr(movement)
    from = pos[0]
    to = pos[1]

    cell = @board[get_index(from)]
    figure = cell.content
    cell.content = colorize("  ", :no_color, cell.color)

    set_figure(figure, to)

  end

  private

  def init
    # pawns
    (0..7).each do |col|
      p_black = Pawn.new(:black)
      set_figure(p_black, [1, col])
      #@board[get_index([1, col])].content = p_black
    end

    (0..7).each do |col|
      p_white = Pawn.new(:no_color)
      set_figure(p_white, [6, col])
      #@board[get_index([6, col])].content = p_white
    end

    # rook
    r1_black = Rook.new(:black)
    r2_black = Rook.new(:black)
    set_figure(r1_black, [0, 0])
    set_figure(r2_black, [0, 7])
    #@board[get_index([0, 0])].content = r1_black
    #@board[get_index([0, 7])].content = r2_black

    # knight
    k1_black = Knight.new(:black)
    k2_black = Knight.new(:black)
    set_figure(k1_black, [0, 1])
    set_figure(k2_black, [0, 6])
    #@board[get_index([0, 1])].content = k1_black
    #@board[get_index([0, 6])].content = k2_black

    # bishop
    b1_black = Bishop.new(:black)
    b2_black = Bishop.new(:black)
    set_figure(b1_black, [0, 2])
    set_figure(b2_black, [0, 5])
    #@board[get_index([0, 2])].content = b1_black
    #@board[get_index([0, 5])].content = b2_black

    # queen
    q_black = Queen.new(:black)
    set_figure(q_black, [0, 3])
    #@board[get_index([0, 3])].content = q_black

    # king
    ki_black = King.new(:black)
    set_figure(ki_black, [0, 4])
    #@board[get_index([0, 4])].content = ki_black

    # white
    # rook
    r1_white = Rook.new(:no_color)
    r2_white = Rook.new(:no_color)
    set_figure(r1_white, [7, 0])
    set_figure(r2_white, [7, 7])
    #@board[get_index([7, 0])].content = r1_white
    #@board[get_index([7, 7])].content = r2_white

    # knight
    k1_white = Knight.new(:no_color)
    k2_white = Knight.new(:no_color)
    set_figure(k1_white, [7, 1])
    set_figure(k2_white, [7, 6])
    #@board[get_index([7, 1])].content = k1_white
    #@board[get_index([7, 6])].content = k2_white

    # bishop
    b1_white = Bishop.new(:no_color)
    b2_white = Bishop.new(:no_color)
    set_figure(b1_white, [7, 2])
    set_figure(b2_white, [7, 5])
    #@board[get_index([7, 2])].content = b1_white
    #@board[get_index([7, 5])].content = b2_white

    # queen
    q_white = Queen.new(:no_color)
    set_figure(q_white, [7, 3])
    #@board[get_index([7, 3])].content = q_white

    # king
    ki_white = King.new(:no_color)
    set_figure(ki_white, [7, 4])
    #@board[get_index([7, 4])].content = ki_white
  end

end
