require_relative '../app/models/Association.rb'
require_relative '../app/models/Category.rb'
require_relative '../app/models/Game.rb'
require_relative '../app/models/Player.rb'
require_relative '../app/models/Question.rb'


# Seed players
todd = Player.create(username: "Todd", total_score: 90)
gene = Player.create(username: "Gene", total_score: 80)

jason = Player.create(username: "Jason", total_score: 50)
tim = Player.create(username: "Tim", total_score: 90)
es = Player.create(username: "Es", total_score: 50)

anon_1 = Player.create(username: "Anon 1", total_score: 100)
anon_2 = Player.create(username: "Anon 2", total_score: 4)
anon_3 = Player.create(username: "Anon 3", total_score: 3)
anon_4 = Player.create(username: "Anon 4", total_score: 2)
anon_5 = Player.create(username: "Anon 5", total_score: 1)

# Seed games
game_1 = Game.create(players: [todd, gene], mode: "First 2 One-Hundred", difficulty: "Easy")
game_2 = Game.create(players: [jason, tim, es], mode: "First 2 One-Hundred", difficulty: "Easy")
game_3 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "First 2 One-Hundred", difficulty: "Hard")
game_4 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Survival", difficulty: "Hard")
game_3 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Jeopardy", difficulty: "Hard")
game_4 = Game.create(players: [anon_1, anon_2, anon_3, anon_4, anon_5], mode: "Survival", difficulty: "Hard")
