class Player < ActiveRecord::Base
  has_many :associations
  has_many :games, through: :associations
  has_many :questions, through: :associations
  has_many :categories, through: :questions

  def self.create_new_players(number)
    playerArray = []
    number.to_i.times do |time|
      puts "What is player #{time + 1}'s username?"
      name = gets.chomp
      new_player = Player.create(username: name, total_score: 0)
      playerArray << new_player
    end
    playerArray
  end

  def get_response_from_player(mult_choice)
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
    response
  end




end
