class Question < ActiveRecord::Base
  belongs_to :category

  has_many :associations
  has_many :players, through: :associations
  has_many :games, through: :associations



  def self.create_and_assign_score(hash)
    score = 0
    case hash['difficulty']
    when 'easy'
      score = 5
    when 'medium'
      score = 10
    when 'hard'
      score = 20
    end
    [Question.create(content: hash["question"], type: hash['type'], difficulty: hash['difficulty'], score: score, correct_answer: hash["correct_answer"]), hash['incorrect_answers']]

  end

  def display_to_player(inc_array)
    puts "-- #{self.category}: -------------------------"
    puts "-- #{self.content} --"
    responses = [inc_array, self.correct_answer].flatten.shuffle
    puts "     a) #{responses[0]}"
    puts "     b) #{responses[1]}"
    puts "     c) #{responses[2]}"
    puts "     d) #{responses[3]}"
  end

  def is_user_correct?(response)
    response.downcase == self.correct_answer.split('').first
  end

end
