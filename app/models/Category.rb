class Category < ActiveRecord::Base
  has_many :questions
  has_many :players, through: :associations
  has_many :games, through: :associations
end
