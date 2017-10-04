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

end
