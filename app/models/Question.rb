class Question < ActiveRecord::Base
  belongs_to :category
  has_many :players
  has_many :games, through: :players
end
