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
    puts "3. Exit Game"
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
    mode = gets.chomp
    if mode == '1'
      self.mode = 'Survival'
    elsif mode == '2'
      self.mode = 'First 2 One-Hundred'
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

  def run_game
    # ----- code to pull data from api -----
    request_hash = {:amount => 50, :category => nil, :difficulty => self.difficulty, :type => 'multiple' }
    new_api = ApiConnection.new(request_hash)
    question_hash = new_api.get_questions

    # ----- create cycler from all players in game object -----
    player_array = self.players
    player_cycler = player_array.cycle

    while true
      # ----- cycle to next player object -----
      current_player = player_cycler.next

      # ----- check if question hash empty; if yes, refresh api request -----
      if question_hash == nil
        question_hash = new_api.get_questions
      end

      # ----- shift to next question in question_hash from api -----
      next_question = question_hash.shift

      # ----- create question object; pass along incorrect MC ansswers -----
      current_question, incorrect_resp = Question.create_and_assign_score(next_question)
      current_player.questions << current_question

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

      if game_over?(current_player)
        puts "Game Over. Thanks for playing!"
        display_scores(player_array)
        # Breaking out of while loop
        break
      end
    end
  end

  def game_over?(player)
    case self.mode
    when "Race 2 One-Hundred"
      player.total_score >= 100
    when "Survival"
      puts "Would you like to continue? (Y/N)"
      input = gets.strip.downcase
      case input
      when "y" || "yes"
        false
      when "n" || "no"
        true
      else
        puts "Invalid input. Please try again."
        game_over?(player)
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
        puts "Thanks for playing!"
        break
      else
        puts "Invalid input. Please try again."
      end
    end
  end
end
