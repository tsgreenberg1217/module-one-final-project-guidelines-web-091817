def ttt_board
  board = []
  3.times do |x|
    board << [" "," "," "]
  end
  board
end

def player_choose_postion(player)
  display_TTT_board
  "choose your position!"
  "Enter your row:"
  row = gets.chomp.to_i
  "In column 1, 2, or 3?"
  column = gets.chomp.to_i
  ttt_board[row-1][column-1] = player.ttt_symbol
  display_TTT_board
end

def display_TTT_board(board)
puts " #{board[0][0]} | #{board[0][1]} | #{board[0][2]} "
puts "-----------"
puts " #{board[1][0]} | #{board[1][1]} | #{board[1][2]} "
puts "-----------"
puts " #{board[2][0]} | #{board[2][1]} | #{board[2][2]} "
end

def players_choose_symbols(array)
  chosen_player = array.first
  puts "#{chosen_player.username}, choose X's or O's"
  response = gets.chomp.downcase
  case response
  when 'x'
    chosen_player.ttt_symbol = 'X'
    array.last.ttt_symbol = 'O'
  when 'o'
    chosen_player.ttt_symbol = 'O'
    array.last.ttt_symbol = 'X'
  else
    puts "Invalid response, choose X or O"
    players_choose_symbols(array)
end



def run_tic_tac_toe
  question_hash = get_data_from_api

  # ----- create cycler from all players in game object -----
  player_array = self.players
  players_choose_symbols(player_array)
  player_cycler = player_array.cycle

  while true
    # ----- cycle to next player object -----
    current_player = player_cycler.next

    # ----- check if question hash empty; if yes, refresh api request -----
    if question_hash == nil
      question_hash = get_data_from_api
    end

    # ----- shift to next question in question_hash from api -----
    next_question = question_hash.shift

    # ----- create question object; pass along incorrect MC ansswers -----
    current_question, incorrect_resp = Question.create_and_assign_score(next_question)
    current_player.questions << current_question

    puts "#{current_player.username}, it's your turn!"
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
      #current_player.total_score += current_question.score
      player_choose_postion(current_player)
    else
      puts "Sorry, that is not the right answer. The correct answer is #{current_question.correct_answer}."
    end

    if game_over?(current_player)
      puts "Game Over. Thanks for playing!"
      #display_scores(player_array)
      # Breaking out of while loop
      break
    end
  end
end


def vertical?(board)
  3.times do |x|
    array = []
    3.times do |y|
      array << board[y][x]
    end
      return true if array.uniq.length == 1 && array.uniq.first != " "
  end
  return false
end


def accross?(board)
  3.times do |x|
    array = []
    3.times do |y|
      array << board[x][y]
    end
      return true if array.uniq.length == 1 && array.uniq.first != " "
  end
  return false
end


def diagonal_1?(board)
  [board[0][0],board[1][1],board[2][2]].uniq.length == 1 && [board[0][0],board[1][1],board[2][2]].uniq.first != " "
end

def diagonal_2?(board)
  [board[0][2],board[1][1],board[2][0]].uniq.length == 1 && [board[0][2],board[1][1],board[2][0]].uniq.first != " "
end


def check_whole_board
  [vertical?(ttt_board), accross?(ttt_board), diagonal_1?(ttt_board), diagonal_2?(ttt_board)].include? (true)
end

end
