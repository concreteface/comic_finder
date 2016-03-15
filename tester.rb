require 'httpclient'
require 'net/http'
require 'json'
require 'dotenv'
require 'comic_vine'
Dotenv.load

# date1 = Date.parse()
# date2 = Date.parse()
# result_limit = INT

base_url = URI.parse("http://comicvine.gamespot.com")
url = URI.parse("http://comicvine.gamespot.com/api/issues/?api_key=#{ENV['COMICVINE_KEY']}&format=json&filter=cover_date:2015-08-12&sort=name:asc&field_list=name")
resp = Net::HTTP.get_response(url)
result = JSON.parse(resp.body)



result.values[6].each do |res|
  if !res['name'].nil?
    puts res['name']
  end
end


# ComicVine::API.key = "#{ENV['COMICVINE_KEY']}"
# chars = ComicVine::API.characters
# chars.each do |char|
#   puts char.name
# end
