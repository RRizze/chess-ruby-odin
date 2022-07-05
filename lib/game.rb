require_relative "board"
require_relative "player"

class Game

  @@mods = ["pvp", "ai"]
  @@ESC = {
    clr_screen: "\e[H\e[2J",
    clr: "\e[0J",
    move: -> (n) { "\e[#{n}A" }
  }

  def clear_screen
    puts @@ESC[:clr_screen]
  end

  def clear_lines(n)
    print @@ESC[:move].call(n)
    print @@ESC[:clr]
  end

  def greetings
    puts "Hello there!"
  end

  def choose_mode
    mode_txt = <<~HEREDOC
      Choose your mode:
        'pvp' - Human vs Human
        'ai' - Human vs Computer

    HEREDOC
    puts mode_txt
  end

  def txt_move(player, success)
    move_txt = <<~HEREDOC
      Your moves should be like: 'e3-e4'

    HEREDOC

    move_player_txt = "#{player[:color].to_s.capitalize} player does move: "
    err = "Wrong piece or move!!! "

    if success
      puts move_txt
      print move_player_txt
    else
      puts move_txt
      print err, move_player_txt
    end
  end

  def pvp_start
    board = Board.new
    board.fill()

    king_w = board.get_piece([0, 4])
    king_b = board.get_piece([7, 4])

    players = [Player.new(:white, king_w), Player.new(:black, king_b)]

    current_player = players[0]

    while true
      board.print_board

      # check for 'check' and 'checkmate'
      res = current_player[:king].checkmate?()

      if res == :check
        puts "Check. Protect your king!"
      elsif res == :checkmate
        print "#{current_player[:color].to_s.capitalize} is lost. Game over."
        break
      end

      txt_move(current_player, true)
      move = gets.chomp

      success = false

      # TODO change success logic
      until success = board.move(move, current_player) do
        clear_lines(3)
        txt_move(current_player, success)
        move = gets.chomp
      end

      if current_player.color == :white
        current_player = players[1]
      else
        current_player = players[0]
      end
      clear_screen
    end
  end

  def loop
    choose_mode

    mode = gets.chomp
    until @@mods.include?(mode)
      clear_lines(2)
      puts "Wrong mode. Chose 'pvp' or 'ai'"
      mode = gets.chomp
    end

    if mode == "pvp"
      clear_screen
      pvp_start
    else
      clear_screen
      ai_start
    end

  end

end
