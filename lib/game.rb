require_relative "board"

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
      "Choose your mode:
        'pvp' - Human vs Human
        'ai' - Human vs Computer

    HEREDOC
    puts mode_txt
  end

  def pvp_start
    board = Board.new

    while true
      board.print_board
      puts "Your moves should be like: 'e3-e4'"
      print "Make your move: "
      move = gets.chomp
      board.move(move)
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
