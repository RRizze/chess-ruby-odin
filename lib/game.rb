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

  def save_game(game_state)
    state = generate_fen(game_state)

    json_data = JSON.generate(state)
    File.open("save_game.json", "w") do |file|
      file.write(json_data)
    end
  end

  def generate_fen(game_state)
    res = ""
    empty_count = 0
    delimetr = "\\"
    game_state[:board].each_with_index do |cell, index|
      if (index + 1) % 8 == 0 and index != board.length - 1
        res += delimetr
        empty_count = 0
      else
        if cell.content.is_a?(String)
          empty_count += 1
        else
          res += empty_count.to_s
          res += cell.content.get_fen
        end
      end
    end
    res += " "
    res += game_state[:future_move]
    res += " "
    res += game_state[:castling]
    res += " "
    res += game_state[:en_passant_pos]
    res += " "
    res += game_state[:halfmove] || "0"
    res += " "
    res += game_state[:fullmove]
  end

  def load_last_game
    filename = "save_game.json"
    if File.exists?(filename)
      file = File.read(filename, encoding: "utf-8")
      game_state = JSON.parse(file)
      return game_state
    else
      return false
    end
  end

  def pvp_start(game_state)
    board = nil
    players = nil
    king_w = nil
    king_b = nil
    if game_state
      board = game_state["board"]
      players = game_state["players"]
    else
      board = Board.new
      board.fill()
      king_w = board.get_piece([0, 4])
      king_b = board.get_piece([7, 4])
      players = [Player.new(:white, king_w), Player.new(:black, king_b)]
    end

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

      if move == "save"
        player_color = current_player.color == :black ? :white : :black
        new_game_state = {
          future_move: player_color,
          castling: board.castling,
          en_passant_pos: board.en_passant_pos,
          halfmove: "0",
          fullmove: "1",
          board: board
        }
        save_game(new_game_state)
        break
      end

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
