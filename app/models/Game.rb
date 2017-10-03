class Game < ActiveRecord::Base
  has_many :players
  has_many :questions, through: :players
  has_many :categories, through: :questions

  def main_menu
    welcome
    while input ||= true
      display_menu
      input = gets.chomp
      case input
      when '1'
        #start_game
          #get_player_names
          #define_type_of_game
          #difficulty
          #category
          #play_game
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



  def get_players
    players.all.each do |player|
      "#{player.first_name} #{player.last_name}"
    end
  end

  def start_game
    @players = get_players
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
  end

  def get_difficulty
    puts "Choose your difficulty:"
    puts "Easy --- Medium --- Hard"
    diff = gets.chomp.downcase
  end

end
