require 'rest-client'
require 'json'
require 'pry'

# all_characters = RestClient.get('http://www.swapi.co/api/people/')
# character_hash = JSON.parse(all_characters)
byebug
#
# initial_link = 'http://chroniclingamerica.loc.gov/search/titles/results/?terms=michigan&format=json&page=1'
# def get_api_info(link)
#   api_info = JSON.parse(RestClient.get(link))
# end
# byebug


uri = URI("https://api.nytimes.com/svc/search/v2/articlesearch.json")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
uri.query = URI.encode_www_form({
  "api-key" => "563720b6f34247bfb3a8f36ae853177a",
  "page" => 1
})
request = Net::HTTP::Get.new(uri.request_uri)
@result = JSON.parse(http.request(request).body)
puts @result.inspect
byebug
