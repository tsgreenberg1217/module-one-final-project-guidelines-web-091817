require_relative '../../lib/apiconnection.rb'

class Game < ActiveRecord::Base
  has_many :associations
  has_many :players, through: :associations
  has_many :questions, through: :associations
  has_many :categories, through: :questions



  def main_menu
    welcome
    while input ||= true
      display_menu
      input = gets.chomp
      case input
      when '1'
        start_game
        #run_game
      when '2'
        #show_high_scores
      when '3'
        break
      else
        puts 'invalid input'
      end
    end
  end

  def welcome
    puts "Welcome to the trivia game."
  end

  def display_menu
    puts "1. Start New Game."
    puts "2. View High Scores."
    puts "3. Exit Game"
  end



  def start_game
    get_players.each {|player| self.players << player }
    get_type_of_game
    get_difficulty
  end

  def get_players
    puts "How many players are playing?"
    number = gets.chomp
    Player.create_new_players(number)
  end

  def get_type_of_game
    puts "Choose game type:"
    puts "1. Survival"
    puts "2. First 2 One-hundred"
    type = gets.chomp
    if type == '1'
      self.type = 'Survival'
    elsif type == '2'
      self.type = 'First 2 One-hundred'
    else
      puts 'Invalid response.'
      get_type_of_game
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
    elsif diff = 'hard'
      self.difficulty = 'hard'
    else
      puts 'invalid response'
      get_difficulty
    end
  end

  def run_game
    request_hash = {:amount => 50, :category => nil, :difficulty => self.difficulty, :type => 'multiple' }
    new_api = ApiConnection.new(request_hash)
    question_hash = new_api.get_questions
    player_array = self.players
    player_cycler = player_array.cycle

    while !game_over? #create this method
      current_player = player_cycler.next
      next_question = question_hash.shift
      current_question, incorrect_array = Question.create_and_assign_score(next_question)
      current_player.questions << current_question
      current_question.display_to_player(incorrect_array)



    #get_question_hash
    #-----while !game_over?
    #create_question_object(hash)
    #present question object
    #get player answer
    #record score
    #check if game over
      #true/show score and exit game
      #false/show score and switch player

  end

end
