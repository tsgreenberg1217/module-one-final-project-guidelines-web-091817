require_relative '../app/models/Association.rb'
require_relative '../app/models/Category.rb'
require_relative '../app/models/Game.rb'
require_relative '../app/models/Player.rb'
require_relative '../app/models/Question.rb'


# Seed players
todd = Player.create(username: "Todd", total_score: 100)
gene = Player.create(username: "Gene", total_score: 80)

jason = Player.create(username: "Jason", total_score: 100)
tim = Player.create(username: "Tim", total_score: 100)
es = Player.create(username: "Es", total_score: 100)

anon_1 = Player.create(username: "Anonymous", total_score: 100)
anon_2 = Player.create(username: "Anonymous", total_score: 100)
anon_3 = Player.create(username: "Anonymous", total_score: 100)
anon_4 = Player.create(username: "Anonymous", total_score: 100)
anon_5 = Player.create(username: "Anonymous", total_score: 100)
anon_6 = Player.create(username: "Anonymous", total_score: 6000)
anon_7 = Player.create(username: "Anonymous", total_score: 6000)
anon_8 = Player.create(username: "Anonymous", total_score: 6000)
anon_9 = Player.create(username: "Anonymous", total_score: 5000)
anon_10 = Player.create(username: "Anonymous", total_score: 5000)
anon_11 = Player.create(username: "Anonymous", total_score: 5000)
anon_12 = Player.create(username: "Anonymous", total_score: 400)
anon_13 = Player.create(username: "Anonymous", total_score: 4000)
anon_14 = Player.create(username: "Anonymous", total_score: 4000)
anon_15 = Player.create(username: "Anonymous", total_score: 4000)
anon_16 = Player.create(username: "Anonymous", total_score: 300)
anon_17 = Player.create(username: "Anonymous", total_score: 200)
anon_18 = Player.create(username: "Anonymous", total_score: 100)

# Seed games
game_1 = Game.create(players: [todd, gene], mode: "First 2 One-Hundred", difficulty: "Easy")
game_2 = Game.create(players: [jason, tim, es], mode: "First 2 One-Hundred", difficulty: "Easy")
game_3 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "First 2 One-Hundred", difficulty: "Hard")
game_4 = Game.create(players: [anon_6, anon_7], mode: "Jeopardy", difficulty: nil)
game_5 = Game.create(players: [anon_8, anon_9, anon_10, anon_11], mode: "Jeopardy", difficulty: nil)
game_6 = Game.create(players: [anon_12, anon_13, anon_14, anon_15], mode: "Jeopardy", difficulty: nil)
game_7 = Game.create(players: [anon_16], mode: "Survival", difficulty: "Hard")
game_8 = Game.create(players: [anon_17], mode: "Survival", difficulty: "Hard")
game_9 = Game.create(players: [anon_18], mode: "Survival", difficulty: "Hard")
