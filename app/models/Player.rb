class Player < ActiveRecord::Base
  has_many :games
  has_many :questions
  has_many :categories, through: :questions
end
