def TTT_board
  board = []
  3.times do |x|
    board << [" "," "," "]
  end
  board
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
  player_array = self.players
  players_choose_symbols(player_array)
  player_cycler = player_array.cycle
  while true
    display_TTT_board

  end



  while true
    current_player = player_cycler.next
  end
end
