require_relative "board"
require_relative "player"
require "json"

class Game
  @@mods = ["pvp", "ai", "load"]
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
        'load' - Load the last game
        'pvp' - Human vs Human
        'ai' - Human vs Computer

    HEREDOC
    puts mode_txt
  end

  def txt_move(player, success)
    move_txt = <<~HEREDOC
      Type move like 'e2-e3' or type 'save' to save the game

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

  def save_game(board)
    fen = generate_fen(board)
    game_state = { last_save: fen }

    json_data = JSON.generate(game_state)
    File.open("save_game.json", "w") do |file|
      file.write(json_data)
    end
  end

  def generate_fen(board)
    res = ""
    empty_count = 0
    delimetr = "\\"
    arr = board.board

    (0..7).each do |row|
      (0..7).each do |col|
        cell = arr[col + row*8]
        if !cell.content.is_a?(String)
          res += empty_count == 0 ? "" : "#{empty_count}"
          res += cell.content.get_fen
          empty_count = 0
        else
          empty_count += 1
        end
      end
      res += empty_count == 0 ? "" : "#{empty_count}"
      res += delimetr if row != 7
      empty_count = 0
    end
    res += " "
    res += board.future_move
    res += " "
    res += board.castling
    res += " "
    res += board.en_passant_pos
    res += " "
    res += "#{board.halfmove}"
    res += " "
    res += "#{board.fullmove}"
    res
  end

  def load_last_game
    filename = "save_game.json"
    if File.exists?(filename)
      file = File.read(filename, encoding: "utf-8")
      game_state = JSON.parse(file)
      generate_board(game_state["last_save"])
    else
      return false
    end
  end

  def pvp_start(game_state)
    board = nil
    king_w = nil
    king_b = nil
    if game_state
      board = game_state["board"]
    else
      board = Board.new
      board.fill()
      king_b = board.get_piece([0, 4])
      king_w = board.get_piece([7, 4])
    end

    player_b = Player.new(:black, king_b)
    player_w = Player.new(:white, king_w)

    current_player = player_w

    res = false

    while true
      board.print_board

      # check for 'check' and 'checkmate'
      res = current_player[:king].checkmate?

      if res == :checkmate
        puts "#{current_player[:color].to_s.capitalize} is lost. Game over."
        puts
        break
      end

      if res == :check
        puts "#{current_player[:color]} player. Your king in check!"
        puts
      end

      txt_move(current_player, true)
      move = gets.chomp

      move_state = false

      while !(move_state = board.move(move, current_player)) do
        #clear_lines(3)
        #move_state = board.move(move, current_player)

        txt_move(current_player, move_state)
        move = gets.chomp
      end

      # pseudo code
      # 1. check 'checkmate' or 'check'
      # if 'checkmate' 
      #   print winner or looser
      # if 'check'
      #   print '<your> king in check'
      #   protect <your> king
      #     try to do protect the king
      #       -> accept move
      #       -> check if move is valid and king is not in check
      #         return true



      if move == "save"
        save_game(board)
        break
      end

      if current_player.color == :white
        current_player = player_b
      else
        current_player = player_w
      end
      clear_screen
    end
  end

  def loop
    choose_mode

    mode = gets.chomp
    until @@mods.include?(mode)
      clear_lines(2)
      puts "Wrong mode. Chose 'pvp', 'load' or 'ai'"
      mode = gets.chomp
    end

    case mode
    when "pvp"
      clear_screen
      pvp_start(false)
    when "ai"
      clear_screen
      ai_start
    when "load"
      clear_screen
      game_state = load_last_game
      if game_state
        pvp_start(game_state)
      else
        pvp_start(false)
      end
    end

  end

end
