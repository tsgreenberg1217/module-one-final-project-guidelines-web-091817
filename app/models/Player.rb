class Player < ActiveRecord::Base
  has_many :games
  has_many :questions
  has_many :categories, through: :questions

  def self.create_new_players(number)
    playerArray = []
    number.times do |time|
      puts "What is player #{time + 1}'s username?"
      name = gets.chomp
      new_player = Player.create(username: name)
      playerArray << new_player
    end
    playerArray
  end


end
