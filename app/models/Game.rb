require_relative '../../lib/apiconnection.rb'

class Game < ActiveRecord::Base
  has_many :associations
  has_many :players, through: :associations
  has_many :questions, through: :associations
  has_many :categories, through: :questions

  def self.welcome
    puts "Welcome to WATSON TRIVIA."
  end

  def self.display_menu
    puts "1. Start New Game."
    puts "2. View High Scores."
    puts "3. Play Tic-Tac-Toe"
    puts "4. Exit Game"
  end

  def start_game
    get_players.each {|player| self.players << player }
    get_game_mode
    get_difficulty
  end

  def get_players
    puts "How many players are playing?"
    number = gets.chomp
    Player.create_new_players(number)
  end

  def get_game_mode
    puts "Choose game mode:"
    puts "1. Survival"
    puts "2. First 2 One-Hundred"
    puts "3. Tic-Tac-Toe"
    mode = gets.chomp
    if mode == '1'
      self.mode = 'Survival'
    elsif mode == '2'
      self.mode = 'First 2 One-Hundred'
    elsif mode == '3'
      self.mode = "Tic-Tac-Toe"
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
    request_hash = {:amount => 50, :category => nil, :difficulty => self.difficulty, :type => 'multiple' }
    new_api = ApiConnection.new(request_hash)
    question_hash = new_api.get_questions

  end

  def run_game
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
      current_question, incorrect_resp = Question.create_and_assign_score(next_question)
      current_player.questions << current_question

      puts "#{current_player.username}, it's your turn!"
      # ----- display multiple choice -----
      mult_choice = current_question.display_to_player(incorrect_resp)

      # ----- ask player for response; record response -----


      puts 'Please submit your answer (a-d):'
      while true
        response = gets.chomp.downcase
        case response
        when 'a'
          response = mult_choice[0]
          break
        when 'b'
          response = mult_choice[1]
          break
        when 'c'
          response = mult_choice[2]
          break
        when 'd'
          response = mult_choice[3]
          break
        else
          puts 'Invalid input. Please choose again.'
        end
      end

      # ----- check if right answer; display correct answer if wrong -----
      if response == current_question.correct_answer
        puts 'You are correct!'
        current_player.total_score += current_question.score
      else
        puts "Sorry, that is not the right answer. The correct answer is #{current_question.correct_answer}."
      end

      if game_over?(current_player, response)
        puts "Game Over. Thanks for playing!"
        display_scores(player_array)
        # Breaking out of while loop
        break
      end
    end
  end

  def game_over?(player, response)
    case self.mode
    when "Race 2 One-Hundred"
      if player.total_score >= 100
        puts "#{player.username} wins!"
        true
      else
        false
      end
    # when "Tic-Tac-Toe"
    #   check_whole_board(ttt_board)
    when "Survival"
      if response == current_question.correct_answer
        false
      else
        puts "You got the question wrong, survival mode has ended. Thanks for playing!"
        true
      end
    end
  end

  def display_scores(players)
    players.sort_by {|player| player.total_score}
    puts "------------- FINAL SCORES -------------"
    players.each {|player| puts "#{player.username} - #{player.total_score}"}
    puts "----------------------------------------"
  end

  def self.show_high_scores
    puts "------------- ALL-TIME HIGH SCORES -------------"
    high_scores = self.all.collect {|game| game.players}.flatten.sort {|a,b| b.total_score <=> a.total_score}
    (1..10).to_a.each do |num|
      puts "#{num}. #{high_scores[num-1].username} --------------- #{high_scores[num-1].total_score}"
    end
    puts "-----------------------------------------------"
  end

  def self.run
    Game.welcome

    while input ||= true
      Game.display_menu
      input = gets.chomp
      case input
      when '1'
        new_game = Game.create
        new_game.start_game
        new_game.run_game
      when '2'
        Game.show_high_scores
      when '3'
        new_game = Game.create
        new_game.mode = "Tic-Tac-Toe"
        #creates 2 ttt players and pushes them to game obj
        ttt_players = Player.create_new_players(2)
        ttt_players.each {|player| new_game.players << player}
        ##################################################
        new_game.get_difficulty
        new_game.run_tic_tac_toe
      when '4'
        puts "Thanks for playing!"
        break
      else
        puts "Invalid input. Please try again."
      end
    end
  end



######
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
  puts "    1   2   3"
  puts"          "
  puts "1   #{board[0][0]} | #{board[0][1]} | #{board[0][2]} "
  puts "   -----------"
  puts "2   #{board[1][0]} | #{board[1][1]} | #{board[1][2]} "
  puts "   -----------"
  puts "3   #{board[2][0]} | #{board[2][1]} | #{board[2][2]} "
  puts "    "
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
    current_question, incorrect_resp = Question.create_and_assign_score(next_question)
    current_player.questions << current_question

    puts "#{current_player.username}, it's your turn!"
    # ----- display multiple choice -----
    mult_choice = current_question.display_to_player(incorrect_resp)

    # ----- ask player for response; record response -----


    puts 'Please submit your answer (a-d):'
    while true
      response = gets.chomp.downcase
      case response
      when 'a'
        response = mult_choice[0]
        break
      when 'b'
        response = mult_choice[1]
        break
      when 'c'
        response = mult_choice[2]
        break
      when 'd'
        response = mult_choice[3]
        break
      else
        puts 'Invalid input. Please choose again.'
      end
    end

    # ----- check if right answer; display correct answer if wrong -----
    if response == current_question.correct_answer
      puts 'You are correct!'
      ttt_correct(current_player, board)
    else
      puts "Sorry, that is not the right answer. The correct answer is #{current_question.correct_answer}."
    end
    #binding.pry
    if check_whole_board(board)
      puts "Congrats #{current_player.username}, you got tic-tack toe!"
      break
    end
    if no_blank_space?(board)
      puts "Stalemate"
      break
    end
  end
end

def ttt_correct(player, board)
  display_TTT_board(board)
  puts "choose your position!"
  puts "Enter your row:"
  row = gets.chomp
  check_ttt_square_input(player, board, row)
  puts "Enter your column:"
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


def check_whole_board(board)
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


end
