require 'rest-client'
require 'json'
require 'pry'

# all_characters = RestClient.get('http://www.swapi.co/api/people/')
# character_hash = JSON.parse(all_characters)

api_info = JSON.parse(RestClient.get('http://chroniclingamerica.loc.gov/search/titles/results/?terms=michigan&format=json&page=1'))

binding.pry
