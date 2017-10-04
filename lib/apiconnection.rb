require 'rest-client'
require 'json'
require 'pry'

class ApiConnection
  attr_reader :amount, :category, :difficulty, :type

  def initialize(amount: 50, category: nil, difficulty: nil, type: nil)
    @amount = amount
    @category = category
    @difficulty = difficulty
    @type = type
  end

  def produce_link(amount: @amount, category: @category, difficulty: @difficulty, type: @type)
    hash = {"amount" => amount, "category" => category, "difficulty" => difficulty, "type" => type}
    hash.collect do |key, value|
      "#{key}=#{value}" if value
    end.compact.join("&")
  end

  def get_questions
    link = produce_link(amount: @amount, category: @category, difficulty: @difficulty, type: @type)
    questions_raw = RestClient.get("https://opentdb.com/api.php?" + "#{link}")
    questions_hash = JSON.parse(questions_raw)
    new_questions = questions_hash["results"]
    # { {question 1 hash}, {question 2 hash}, etc. }
    #  keys => ["category", "type", "difficulty", "question", "correct_answer", "incorrect_answers"]
  end
end

# NOTES FOR API
# https://opentdb.com/api.php?[filler]
# filler = amount=?&category=?&difficulty=?&type=?&encode=?
# amount = ? (1..50)
# category = ? (1..32)
# difficulty = ? (easy, medium, hard)
# type = ? (multiple, boolean)
# 
# request_hash = {:amount => 50, :category => nil, :difficulty => nil, :type => nil }
# new_api = ApiConnection.new(request_hash)
# question_hash = new_api.get_questions
#
# current_question = question_hash.first
#
# responses = [current_question["correct_answer"], current_question["incorrect_answers"][0], current_question["incorrect_answers"][1], current_question["incorrect_answers"][2]]
# responses.shuffle!
#
# puts "-- #{current_question["category"]}: -------------------------"
# puts "-- #{current_question["question"]} --"
# puts "     a) #{responses[0]}"
# puts "     b) #{responses[1]}"
# puts "     c) #{responses[2]}"
# puts "     d) #{responses[3]}"
