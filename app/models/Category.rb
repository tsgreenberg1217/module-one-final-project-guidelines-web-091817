class Category < ActiveRecord::Base
  has_many :questions
  has_many :players, through: :questions
  has_many :games, through: :players

end
