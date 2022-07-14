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
    game_state = { last_fen: fen, last_moves: board.moves }

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

    if board.en_passant_pos == "-"
      res += board.en_passant_pos
    else
      res += board.get_board_position(board.en_passant_pos)
    end

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
      board = generate_board(game_state)
      board
    else
      return false
    end
  end

  def generate_board(game_state)
    # data[0] - board, [1] - future_move, [2] - KQkq, [3] - '-'
    board = Board.new
    moves = game_state["last_moves"]
    board.moves = moves
    data = game_state["last_fen"].split(" ")
    board.castling = data[2]
    board.future_move = data[1]
    board.en_passant_pos = data[3]
    board.halfmove = data[4]
    board.fullmove = data[5]

    col = 0
    row = 0
    data[0].each_char do |sym|
      if sym == "\\"
        col = 0
        row += 1
        next
      end

      if (sym =~ /[1-8]/)
        col += sym.to_i
        next
      end

      case sym
      when "r"
        rook = Rook.new(:black, [row, col], board)
        if ([row, col] != [0, 0] and [row, col] != [0, 7])
          rook.did_move = true
        end

        if [row, col] == [0, 0]
          moves.each do |move|
            if move.include?("a8-")
              rook.did_move = true
            end
          end
        end

        if [row, col] == [0, 7]
          moves.each do |move|
            if move.include?("h8-")
              rook.did_move = true
            end
          end
        end
        board.set_piece(rook, [row, col])
        board.blacks << rook

      when "R"
        rook = Rook.new(:no_color, [row, col], board)
        if [row, col] != [7, 0] and [row, col] != [7, 7]
          rook.did_move = true
        end

        if [row, col] == [7, 0]
          moves.each do |move|
            if move.include?("a1-")
              rook.did_move = true
            end
          end
        end

        if [row, col] == [7, 7]
          moves.each do |move|
            if move.include?("h1-")
              rook.did_move = true
            end
          end
        end
        board.set_piece(rook, [row, col])
        board.whites << rook

      when "p"
        pawn = Pawn.new(:black, [row, col], board)
        board.set_piece(pawn, [row, col])
        board.blacks << pawn

      when "P"
        pawn = Pawn.new(:no_color, [row, col], board)
        board.set_piece(pawn, [row, col])
        board.whites << pawn

      when "n", "N"
        color = sym == "n" ? :black : :no_color
        knight = Knight.new(color, [row, col], board)
        board.set_piece(knight, [row, col])
        
        if sym == "n"
          board.blacks << knight
        else
          board.whites << knight
        end

      when "b", "B"
        color = sym == "b" ? :black : :no_color
        bishop = Bishop.new(color, [row, col], board)
        board.set_piece(bishop, [row, col])
        if sym == "b"
          board.blacks << bishop
        else
          board.whites << bishop
        end

      when "q", "Q"
        color = sym == "q" ? :black : :no_color
        queen = Queen.new(color, [row, col], board)
        board.set_piece(queen, [row, col])
        if sym == "q"
          board.blacks << queen
        else
          board.whites << queen
        end

      when "k"
        king = King.new(:black, [row, col], board)

        if [row, col] == [0, 4]
          moves.each do |move|
            if move.include?("e8-")
              king.did_move = true
            end
          end
        end
        board.set_piece(king, [row, col])
        board.blacks << king

      when "K"
        king = King.new(:no_color, [row, col], board)

        if [row, col] == [7, 4]
          moves.each do |move|
            if move.include?("e1-")
              king.did_move = true
              #break
            end
          end
        end
        board.set_piece(king, [row, col])
        board.whites << king
      end

      col += 1
      if col > 7
        col == 0
        #row += 1
      end
    end

    board
  end

  def pvp_start(game_state)
    board = nil
    king_b = nil
    king_w = nil

    if game_state
      board = game_state
    else
      board = Board.new
      board.fill()
    end

    king_b = board.get_king(:black)
    king_w = board.get_king(:no_color)

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

      if move == "save"
        save_game(board)
        break
      end

      move_state = false

      while !(move_state = board.move(move, current_player)) do
        clear_lines(3)
        #move_state = board.move(move, current_player)

        txt_move(current_player, move_state)
        move = gets.chomp

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
      board = load_last_game
      if board
        pvp_start(board)
      else
        pvp_start(false)
      end
    end

  end

end
