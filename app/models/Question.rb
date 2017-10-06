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

  def filter_question(sentence)
   sentence.split('&quot;').join('').split('&#039;').join('')
  end

  def display_to_player(incorrect_resp)
    responses = [incorrect_resp, self.correct_answer].flatten.shuffle
    puts "-- #{self.category.name}:"
    puts "-- #{filter_question(self.content)}"
    puts "     a) #{responses[0]}"
    puts "     b) #{responses[1]}"
    puts "     c) #{responses[2]}"
    puts "     d) #{responses[3]}"
    puts "-------------------------------------------------------"
    puts ""
    responses
  end

  def is_user_correct?(response)
    response.downcase == self.correct_answer.split('').first
  end

  def self.create_and_associate_to_player(hash, player)
      current_question, incorrect_resp = self.create_and_assign_score(hash)
      player.questions << current_question
      [current_question, incorrect_resp]
  end

  def correct?(response)
    if response == self.correct_answer
      puts 'You are correct!'
      true
    else
      puts "Sorry, that is not the right answer. The correct answer is #{self.correct_answer}."
      false
    end
  end

end
