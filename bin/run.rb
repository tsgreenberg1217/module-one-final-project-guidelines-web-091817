require_relative '../config/environment.rb'
require_relative '../lib/apiconnection.rb'
require_relative '../app/models/Association.rb'
require_relative '../app/models/Category.rb'
require_relative '../app/models/Game.rb'
require_relative '../app/models/Player.rb'
require_relative '../app/models/Question.rb'

Game.run
