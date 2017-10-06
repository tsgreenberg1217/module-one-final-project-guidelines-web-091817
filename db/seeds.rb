require_relative '../app/models/Association.rb'
require_relative '../app/models/Category.rb'
require_relative '../app/models/Game.rb'
require_relative '../app/models/Player.rb'
require_relative '../app/models/Question.rb'


# Seed players
todd = Player.create(username: "Todd", total_score: 100)
gene = Player.create(username: "Gene", total_score: 80)

jason = Player.create(username: "Jason", total_score: 50)
tim = Player.create(username: "Tim", total_score: 100)
es = Player.create(username: "Es", total_score: 50)

anon_1 = Player.create(username: "Anon 1", total_score: 100)
anon_2 = Player.create(username: "Anon 2", total_score: 4)
anon_3 = Player.create(username: "Anon 3", total_score: 3)
anon_4 = Player.create(username: "Anon 4", total_score: 2)
anon_5 = Player.create(username: "Anon 5", total_score: 1)
anon_6 = Player.create(username: "Anon 6", total_score: 6000)
anon_7 = Player.create(username: "Anon 7", total_score: 6000)
anon_8 = Player.create(username: "Anon 8", total_score: 6000)
anon_9 = Player.create(username: "Anon 9", total_score: 5000)
anon_10 = Player.create(username: "Anon 10", total_score: 5000)
anon_11 = Player.create(username: "Anon 11", total_score: 5000)
anon_12 = Player.create(username: "Anon 12", total_score: 5000)
anon_13 = Player.create(username: "Anon 13", total_score: 4000)
anon_14 = Player.create(username: "Anon 14", total_score: 4000)
anon_15 = Player.create(username: "Anon 15", total_score: 4000)

# Seed games
game_1 = Game.create(players: [todd, gene], mode: "First 2 One-Hundred", difficulty: "Easy")
game_2 = Game.create(players: [jason, tim, es], mode: "First 2 One-Hundred", difficulty: "Easy")
game_3 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "First 2 One-Hundred", difficulty: "Hard")
game_4 = Game.create(players: [anon_6, anon_7], mode: "Jeopardy", difficulty: nil)
game_5 = Game.create(players: [anon_8, anon_9, anon_10, anon_11], mode: "Jeopardy", difficulty: nil)
game_6 = Game.create(players: [anon_12, anon_13, anon_14, anon_15], mode: "Jeopardy", difficulty: nil)
game_4 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Survival", difficulty: "Hard")
game_3 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Jeopardy", difficulty: "Hard")
game_4 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Survival", difficulty: "Hard")
