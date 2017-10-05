require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_relative '../lib/apiconnection.rb'
require_relative '../app/models/Association.rb'
require_relative '../app/models/Category.rb'
require_relative '../app/models/Game.rb'
require_relative '../app/models/Player.rb'
require_relative '../app/models/Question.rb'

# require_all'app'
# require_all'lib'
