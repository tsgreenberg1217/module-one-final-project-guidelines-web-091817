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
    new_question = Question.find_or_create_by(content: hash["question"], answer_type: hash['type'], difficulty: hash['difficulty'], score: score, correct_answer: hash["correct_answer"])
    new_category = Category.find_or_create_by(name: hash["category"])
    new_category.questions << new_question

    [new_question, hash['incorrect_answers']]
  end

  def display_to_player(incorrect_resp)
    responses = [incorrect_resp, self.correct_answer].flatten.shuffle
    puts "-- #{self.category.name}: -------------------------"
    puts "-- #{self.content} --"
    puts "     a) #{responses[0]}"
    puts "     b) #{responses[1]}"
    puts "     c) #{responses[2]}"
    puts "     d) #{responses[3]}"
    responses
  end

  def is_user_correct?(response)
    response.downcase == self.correct_answer.split('').first
  end

end
