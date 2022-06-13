#!/usr/bin/sh ruby
require_relative "board"
require_relative "queen"

class Game


end

board = Board.new
board.print_board

board.move("e2-e3")
board.move("b8-c6")
board.print_board
