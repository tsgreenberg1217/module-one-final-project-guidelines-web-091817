class Game < ActiveRecord::Base
  has_many :players
  has_many :questions, through: :players
  has_many :categories, through: :questions
end
