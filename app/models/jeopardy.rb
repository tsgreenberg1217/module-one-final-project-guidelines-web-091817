# JEOPARDY GAME
class Game
  def assign_categories
    all_categories = [
      # 11 unique categories
      # [ Category, Cat_ID ]
      ["Books", 10],
      ["Film", 11],
      ["Music", 12],
      ["TV", 14],
      ["Math", 19],
      ["Mythology", 20],
      ["Sports", 21],
      ["Geography", 22],
      ["History", 23],
      ["Politics", 24],
      ["Art", 25]
    ]

    all_categories.shuffle[0..3]
  end

  def display_board(board, cats)
    puts "                                                       "
    puts "-------------------------------------------------------"
    puts "--------------------- JEOPARDY! -----------------------"
    puts "-------------------------------------------------------"
    puts "                                                       "
    puts "     1: #{cats["1"]}  //  2: #{cats["2"]}  //  3: #{cats["3"]}  //  4: #{cats["4"]}"
    puts "                                                       "
    puts "        ----- 1 ------ 2 ------- 3 ------- 4 -----     "
    puts "        ------------------------------------------     "
    puts "     a: ||  #{board["a1"]}  ||  #{board["a2"]}  ||  #{board["a3"]}  ||  #{board["a4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "     b: ||  #{board["b1"]}  ||  #{board["b2"]}  ||  #{board["b3"]}  ||  #{board["b4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "     c: ||  #{board["c1"]}  ||  #{board["c2"]}  ||  #{board["c3"]}  ||  #{board["c4"]}  ||     "
    puts "        ------------------------------------------     "
    puts "                                                       "
    puts "-------------------------------------------------------"
    puts "                                                       "
  end

  def request_move(board)
    puts "Please choose a position on the board: "
    move = gets.strip
    if !board.keys.include?(move) || board[move] == "    "
      puts "Invalid. Please choose again."
      request_move(board)
    else
      move
    end
  end

  def change_board(board, move)
    board[move] = "    "
  end

  def welcome
    puts "Welcome to Jeopardy!"
  end

  def board_empty?(board)
    board.values.all? {|tile| tile == "    "}
  end

  def announce_winner
    puts "Congratulations, #{self.players.max_by {|player| player.total_score}.username}. You are the winner!"
  end


  def find_ques_attributes_by_move(move, cats, board)
    # ----- find category and difficulty -----
    q_category = cats.fetch(move[-1])

    case move[0]
    when "a"
      q_difficulty = "easy"
    when "b"
      q_difficulty = "medium"
    when "c"
      q_difficulty = "hard"
    else
      q_difficulty = "nil"
    end

    q_score = board[move]

    [q_category, q_difficulty, q_score]
  end

  def run_jeopardy
    cat_1, cat_2, cat_3, cat_4 = assign_categories

    cats = {"1" => cat_1[0], "2" => cat_2[0], "3" => cat_3[0], "4" => cat_4[0]}

    board = {"a1" => "2000", "a2" => "2000", "a3" => "2000", "a4" => "2000",
      "b1" => "1000", "b2" => "1000", "b3" => "1000", "b4" => "1000",
      "c1" => " 500", "c2" => " 500", "c3" => " 500", "c4" => " 500"}

    welcome

    while true
      display_board(board, cats)

      # ----- code to pull data from api (REDO)-----
      cats_api_request = [cat_1[1], cat_2[1], cat_3[1], cat_3[1]]
      diff_api_request = ["easy", "medium", "hard"]
      question_hash = []

      cats_api_request.each do |cat|
        diff_api_request.each do |diff|
          request_hash = {:amount => 10, :category => cat, :difficulty => diff, :type => 'multiple'}
          new_api = ApiConnection.new(request_hash)
          question_hash << new_api.get_questions
        end
      end
      question_hash.flatten.compact.delete({})

      # ----- create cycler from all players in game object -----
      player_array = self.players
      player_cycler = player_array.cycle

      while true
        # ----- cycle to next player object -----
        current_player = player_cycler.next

        # ----- request move from player -----
        move = request_move(board)
        q_category, q_difficulty, q_score = find_ques_attributes_by_move(move, cats, board)

        # ----- shift to next question in question_hash from api -----
        next_question = question_hash.find do |hash|
          hash["category"] == q.category && hash["difficulty"] == q_difficulty
        end

        if next_question == nil
          next_question = question_hash.find do |hash|
            hash["category"] == q.category && hash["difficulty"] == "medium"
          end
        end

        question_hash.delete(next_question)

        # ----- create question object; pass along incorrect MC answers -----
        current_question, incorrect_resp = Question.create_and_assign_score(next_question)
        current_player.questions << current_question

        # ----- display multiple choice -----
        mult_choice = current_question.display_to_player(incorrect_resp)

        # ----- ask player for response; record response -----
        puts 'Please submit your answer (a-d):'

        while true
          response = gets.chomp.downcase
          case response
          when 'a'
            response = mult_choice[0]
            break
          when 'b'
            response = mult_choice[1]
            break
          when 'c'
            response = mult_choice[2]
            break
          when 'd'
            response = mult_choice[3]
            break
          else
            puts 'Invalid input. Please choose again.'
          end
        end

        # ----- check if right answer; display correct answer if wrong -----
        if response == current_question.correct_answer
          puts 'You are correct!'
          current_player.total_score += q.score
          change_board(board, move)
        else
          puts "Sorry, that is not the right answer. The correct answer is #{current_question.correct_answer}."
        end

        if board_empty?(board)
          break
        end
      end
      display_board(board, cats)
      announce_winner
      break
    end
    display_scores(player_array)
    puts "Game over! Thanks for playing."
  end
end

# TESTING
game = Game.new
game.run_jeopardy
