require_relative '../../lib/apiconnection.rb'
require_relative '../../db/jeopardydata.rb'

class Game < ActiveRecord::Base
  has_many :associations
  has_many :players, through: :associations
  has_many :questions, through: :associations
  has_many :categories, through: :questions

  def self.welcome
    puts "Welcome to WATSON TRIVIA."
  end

  def self.display_menu
    puts "1. Play Game"
    puts "2. View High Scores"
    puts "3. Exit Game"
  end

  def start_game
    get_game_mode
    get_players.each {|player| self.players << player }
    get_difficulty if self.mode == "Survival" || self.mode == "First 2 One-Hundred"
  end

  def get_players
    if self.mode == "Tic-Tac-Toe"
      Player.create_new_players(2)
    else
      puts "How many players are playing?"
      number = gets.chomp
      Player.create_new_players(number)
    end
  end

  def get_game_mode
    puts "Choose game mode:"
    puts "1. Survival"
    puts "2. First 2 One-Hundred"
    puts "3. Tic-Tac-Toe"
    puts "4. Jeopardy"
    mode = gets.chomp
    if mode == '1'
      self.mode = 'Survival'
    elsif mode == '2'
      self.mode = "First 2 One-Hundred"
    elsif mode == '3'
      self.mode = 'Tic-Tac-Toe'
    elsif mode == '4'
      self.mode = "Jeopardy"
    else
      puts 'Invalid response.'
      get_game_mode
    end
  end

  def get_difficulty
    puts "Choose your difficulty:"
    puts "Easy --- Medium --- Hard"
    diff = gets.chomp.downcase

    if diff == 'easy'
      self.difficulty = 'easy'
    elsif diff == 'medium'
      self.difficulty = 'medium'
    elsif diff == 'hard'
      self.difficulty = 'hard'
    else
      puts 'invalid response'
      get_difficulty
    end
  end

  def get_data_from_api
    # ----- code to pull data from api -----
    request_hash = {:amount => 50, :category => nil, :difficulty => self.difficulty, :type => 'multiple'}
    new_api = ApiConnection.new(request_hash)
    question_hash = new_api.get_questions
  end

  def run_og_game
    question_hash = get_data_from_api

    # ----- create cycler from all players in game object -----
    player_array = self.players
    player_cycler = player_array.cycle

    while true
      # ----- cycle to next player object -----
      current_player = player_cycler.next

      # ----- check if question hash empty; if yes, refresh api request -----
      if question_hash == nil
        question_hash = get_data_from_api
      end

      # ----- shift to next question in question_hash from api -----
      next_question = question_hash.shift

      # ----- create question object; pass along incorrect MC ansswers -----
      ##### OG CODE
      # current_question, incorrect_resp = Question.create_and_assign_score(next_question)
      # current_player.questions << current_question
      ##### OG CODE
      current_question, incorrect_resp = Question.create_and_associate_to_player(next_question, current_player)


      puts "#{current_player.username}, it's your turn!"

      # ----- display multiple choice -----
      mult_choice = current_question.display_to_player(incorrect_resp)

      # ----- ask player for response; record response -----
      response = current_player.get_response_from_player(mult_choice)


      # ----- check if right answer; display correct answer if wrong -----
      if current_question.correct?(response)
         current_player.total_score += current_question.score
      end

      if game_over?(current_player, response, current_question.correct_answer, board = nil)
        self.players.each{|player| player.save}
        self.save
        puts "Game Over. Thanks for playing!"
        display_scores(player_array)
        # Breaking out of while loop
        break
      end
    end
  end

  def game_over?(player, response, correct_answer, board)
    case self.mode
    when "First 2 One-Hundred"
      if player.total_score >= 100
        puts "#{player.username} wins!"
        true
      else
        false
      end
    when "Survival"
      if response == correct_answer
        false
      else
        puts "You got the question wrong, survival mode has ended. Thanks for playing!"
        true
      end
    when "Tic-Tac-Toe"
      if check_for_winner?(board)
        puts "Congrats #{player.username}, you got tic-tack toe!"
        return true
      end
      if no_blank_space?(board)
        puts "Stalemate"
        return true
      end
        return false
    end
  end

  def display_scores(players)
    players.sort_by {|player| player.total_score}
    puts "--------------------- SCORES --------------------------"
    players.each {|player| puts "#{player.username} - #{player.total_score}"}
    puts "-------------------------------------------------------"
  end

  def self.show_high_scores
    #binding.pry
    ["First 2 One-Hundred", "Survival", "Jeopardy"].each do |game_name|
      #binding.pry
      place = (1..10).to_a.cycle
      puts "        "
      puts"TOP 10 SCORES FOR #{game_name.upcase}"
      puts "---------------------------------"
      self.all.select{|game_1| game_1.mode == game_name}.collect{|game| game.players}.flatten.sort {|a,b| b.total_score <=> a.total_score}[0..9].each{|player| puts "#{place.next}.#{player.username} -------------------- #{player.total_score}"}
      puts " "
    end

    # puts "--------------- ALL-TIME HIGH SCORES ------------------"
    # binding.pry
    # high_scores = self.all.collect {|game| game.players}.flatten.sort {|a,b| b.total_score <=> a.total_score}
    # (1..10).to_a.each do |num|
    #   puts "#{num}. #{high_scores[num-1].username} --------------- #{high_scores[num-1].total_score}"
    # end
    # puts "-------------------------------------------------------"
  end

  # -----------------------------------------------------------------------------
  # ***** MAIN RUNNER FILE *****
  # -----------------------------------------------------------------------------

  def self.run
    Game.welcome

    while input ||= true
      Game.display_menu
      # binding.pry
      input = gets.chomp
      case input
      when '1'
        new_game = Game.create
        new_game.start_game

        case new_game.mode
        when "Survival"
          new_game.run_og_game
        when "First 2 One-Hundred"
          new_game.run_og_game
        when "Jeopardy"
          new_game.run_jeopardy
        when "Tic-Tac-Toe"
          new_game.run_tic_tac_toe
        end
      when '2'
        Game.show_high_scores
      when '3'
        puts "Thanks for playing!"
        break
      else
        puts "Invalid input. Please try again."
      end
    end
  end


# -----------------------------------------------------------------------------
# BEGINNING OF TIC TAC TOE METHODS
# -----------------------------------------------------------------------------
  def ttt_board
    board = []
    3.times do |x|
      board << [" "," "," "]
    end
    board
  end

  def player_choose_postion(player, board)
    display_TTT_board(board)
    puts "choose your position!"
    puts "Enter your row:"
    row = gets.chomp.to_i
    puts "Enter your column:"
    column = gets.chomp.to_i
    board[row-1][column-1] = player.ttt_symbol
    display_TTT_board(board)
  end

  def display_TTT_board(board)
    puts "             "
    puts "       1   2   3"
    puts "          "
    puts "  1:   #{board[0][0]} | #{board[0][1]} | #{board[0][2]} "
    puts "      -----------"
    puts "  2:   #{board[1][0]} | #{board[1][1]} | #{board[1][2]} "
    puts "      -----------"
    puts "  3:   #{board[2][0]} | #{board[2][1]} | #{board[2][2]} "
    puts ""
  end

  def players_choose_symbols(array)
    chosen_player = array.first
    last_player = array.last
    puts "#{chosen_player.username}, choose X's or O's"
    response = gets.chomp.downcase
    case response
      when 'x'
        chosen_player.ttt_symbol = 'X'
        last_player.ttt_symbol = 'O'
      when 'o'
        chosen_player.ttt_symbol = 'O'
        last_player.ttt_symbol = 'X'
      else
        puts "Invalid response, choose X or O"
        players_choose_symbols(array)
      end
      return [chosen_player,last_player]
      #binding.pry
  end


  def run_tic_tac_toe
    board = ttt_board
    question_hash = get_data_from_api

    # ----- create cycler from all players in game object -----
    player_array = players_choose_symbols(self.players)
    player_cycler = player_array.cycle

    while true
      # ----- cycle to next player object -----
      current_player = player_cycler.next

      # ----- check if question hash empty; if yes, refresh api request -----
      if question_hash == nil
        question_hash = get_data_from_api
      end

      # ----- shift to next question in question_hash from api -----
      next_question = question_hash.shift

      # ----- create question object; pass along incorrect MC ansswers -----
      current_question, incorrect_resp = Question.create_and_associate_to_player(next_question, current_player)

      puts "#{current_player.username}, it's your turn!"
      puts ""
      # ----- display multiple choice -----
      mult_choice = current_question.display_to_player(incorrect_resp)

      # ----- ask player for response; record response -----
      response = current_player.get_response_from_player(mult_choice)
      # ----- check if right answer; display correct answer if wrong -----
      if current_question.correct?(response)
        ttt_correct(current_player, board)
      end
      #binding.pry
      if game_over?(current_player, response, current_question.correct_answer, board)
        break
      end
    end
  end


  def ttt_correct(player, board)
    display_TTT_board(board)
    puts "Choose your position!"

    puts "Enter your row (1-3):"
    row = gets.chomp
    check_ttt_square_input(player, board, row)

    puts "Enter your column (1-3):"
    column = gets.chomp
    check_ttt_square_input(player, board, column)

    if board[(row.to_i)-1][(column.to_i)-1] == " "
      board[(row.to_i)-1][(column.to_i)-1] = player.ttt_symbol
      display_TTT_board(board)
    else
      puts "That spot is taken."
      ttt_correct(player, board)
    end
  end

  def check_ttt_square_input(player, board, input)
    if input.to_i > 3 || input.to_i < 1
      puts "invalid response"
      ttt_correct(player, board)
    end
  end

  def vertical?(board)
    3.times do |x|
      array = []
      3.times do |y|
        array << board[y][x]
      end
        return true if array.uniq.length == 1 && array.uniq.first != " "
    end
    return false
  end

  def accross?(board)
    3.times do |x|
      array = []
      3.times do |y|
        array << board[x][y]
      end
        return true if array.uniq.length == 1 && array.uniq.first != " "
    end
    return false
  end

  def diagonal_1?(board)
    [board[0][0],board[1][1],board[2][2]].uniq.length == 1 && [board[0][0],board[1][1],board[2][2]].uniq.first != " "
  end

  def diagonal_2?(board)
    [board[0][2],board[1][1],board[2][0]].uniq.length == 1 && [board[0][2],board[1][1],board[2][0]].uniq.first != " "
  end


  def check_for_winner?(board)
    [vertical?(board), accross?(board), diagonal_1?(board), diagonal_2?(board)].include?(true)
  end

  def no_blank_space?(board)
    3.times do |x|
      3.times do |y|
        return false if board[x][y] == " "
      end
    end
    return true
  end

  # -----------------------------------------------------------------------------
  # BEGINNING OF JEOPARDY METHODS
  # -----------------------------------------------------------------------------

  def assign_categories
    all_categories = [
      # 11 unique categories
      # [ Category, Cat_ID ]
      ["Books", 10],
      ["Entertainment: Film", 11],
      ["Entertainment: Music", 12],
      ["Entertainment: Television", 14],
      ["Math", 19],
      ["Mythology", 20],
      ["Sports", 21],
      ["Geography", 22],
      ["History", 23],
      ["Politics", 24],
      ["Art", 25]
    ]

    # all_categories.shuffle[0..3]
    [["Entertainment: Film", 11], ["Entertainment: Music", 12], ["Entertainment: Television", 14], ["Sports", 21]]
  end

  def display_board(board, cats)
    puts "                                                       "
    puts "-------------------------------------------------------"
    puts "--------------------- JEOPARDY! -----------------------"
    puts "-------------------------------------------------------"
    puts "                                                       "
    puts "     1: #{cats["1"]}  //  2: #{cats["2"]}  //  3: #{cats["3"]}  //  4: #{cats["4"]}"
    puts "                                                       "
    puts "        ----- 1 ------ 2 ------- 3 ------- 4 -----     "
    puts "        ------------------------------------------     "
    puts "     a: ||  #{board["a1"]}  ||  #{board["a2"]}  ||  #{board["a3"]}  ||  #{board["a4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "     b: ||  #{board["b1"]}  ||  #{board["b2"]}  ||  #{board["b3"]}  ||  #{board["b4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "     c: ||  #{board["c1"]}  ||  #{board["c2"]}  ||  #{board["c3"]}  ||  #{board["c4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "                                                       "
    puts "-------------------------------------------------------"
    puts "                                                       "
  end

  def request_move(board)
    puts "Please choose a position on the board (e.g. a1, b2): "
    move = gets.strip
    if !board.keys.include?(move) || board[move] == "    "
      puts "Invalid. Please choose again."
      request_move(board)
    else
      move
    end
  end

  def change_board(board, move)
    board[move] = "    "
  end

  def welcome_jeopardy
    puts "Welcome to Jeopardy!"
  end

  def board_empty?(board)
    board.values.all? {|tile| tile == "    "}
  end

  def announce_winner
    puts "Congratulations, #{self.players.max_by {|player| player.total_score}.username}. You are the winner!"
  end


  def find_ques_attributes_by_move(move, cats, board)
    # ----- find category and difficulty -----
    q_category = cats.fetch(move[-1])

    case move[0]
    when "a"
      q_difficulty = "hard"
    when "b"
      q_difficulty = "medium"
    when "c"
      q_difficulty = "easy"
    else
      q_difficulty = "nil"
    end

    q_score = board[move]

    [q_category, q_difficulty, q_score]
  end

  def run_jeopardy
    cat_1, cat_2, cat_3, cat_4 = assign_categories

    cats = {"1" => cat_1[0], "2" => cat_2[0], "3" => cat_3[0], "4" => cat_4[0]}

    board = {"a1" => "2000", "a2" => "2000", "a3" => "2000", "a4" => "2000",
      "b1" => "1000", "b2" => "1000", "b3" => "1000", "b4" => "1000",
      "c1" => " 500", "c2" => " 500", "c3" => " 500", "c4" => " 500"}

    j_test_data = jeopardy_data.shuffle

    welcome_jeopardy

    while true
      # ----- code to pull data from api -----
      # cats_api_request = [cat_1[1], cat_2[1], cat_3[1], cat_3[1]]
      # diff_api_request = ["easy", "medium", "hard"]
      # question_hash = []
      #
      # cats_api_request.each do |cat|
      #   diff_api_request.each do |diff|
      #     request_hash = {:amount => 10, :category => cat, :difficulty => diff, :type => 'multiple'}
      #     new_api = ApiConnection.new(request_hash)
      #     question_hash << new_api.get_questions
      #   end
      # end
      # question_hash.flatten.compact.delete({})

      # ----- create cycler from all players in game object -----
      player_array = self.players
      player_cycler = player_array.cycle

      while true
        display_board(board, cats)

        # ----- cycle to next player object -----
        current_player = player_cycler.next

        puts "#{current_player.username}, it's your turn!"
        puts ""

        # ----- request move from player -----
        move = request_move(board)
        puts ""
        q_category, q_difficulty, q_score = find_ques_attributes_by_move(move, cats, board)
        change_board(board, move)

        # ----- shift to next question in question_hash from api -----
        # next_question = question_hash.find do |hash|
        #   hash["category"] == q.category && hash["difficulty"] == q_difficulty
        # end
        #
        # if next_question == nil
        #   next_question = question_hash.find do |hash|
        #     hash["category"] == q.category && hash["difficulty"] == "medium"
        #   end
        # end
        #
        # question_hash.delete(next_question)
        # binding.pry
        next_question = j_test_data.find do |hash|
          hash["category"] == q_category && hash["difficulty"] == q_difficulty
        end

        if next_question == nil
          next_question = j_test_data.find do |hash|
            hash["category"] == q_category && hash["difficulty"] == "medium"
          end
        end

        j_test_data.delete(next_question)

        # binding.pry
        # ----- create question object; pass along incorrect MC answers -----
        current_question, incorrect_resp = Question.create_and_associate_to_player(next_question, current_player)

        # ----- display multiple choice -----
        mult_choice = current_question.display_to_player(incorrect_resp)

        # ----- ask player for response; record response -----
        puts 'Please submit your answer (a-d):'

        response = current_player.get_response_from_player(mult_choice)

        # ----- check if right answer; display correct answer if wrong -----
        if current_question.correct?(response)
          current_player.total_score += q_score.to_i
        end

        # ----- display scoreboard -----
        display_scores(player_array)

        if board_empty?(board)
          self.players.each{|player| player.save}
          self.save
          break
        end
      end
      display_board(board, cats)
      announce_winner
      break
    end
    display_scores(player_array)
    puts "Game over! Thanks for playing."
  end
end
