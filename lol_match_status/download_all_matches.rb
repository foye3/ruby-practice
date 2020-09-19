# frozen_string_literal: true

require 'faraday'
require 'json'
require 'yaml'
require 'byebug'

config = YAML.load_file('./config.yml')

summoner_url = "#{config['base_path']}/lol/summoner/v4/summoners/by-name/#{config['summoner_name']}"

response = Faraday.get(summoner_url) do |req|
  req.headers['X-Riot-Token'] = config['api_key']
end

account_id = JSON.parse(response.body)['accountId']
match_list_url = "#{config['base_path']}/lol/match/v4/matchlists/by-account/#{account_id}"

begin_index = 0
matches = []

loop do
  puts begin_index
  response = Faraday.get(match_list_url) do |req|
    req.params['beginIndex'] = begin_index
    req.headers['X-Riot-Token'] = config['api_key']
  end
  response_body = JSON.parse(response.body)
  matches.concat(response_body['matches'])

  begin_index += 100
  sleep(1)
  break if begin_index >= response_body['totalGames']
end

File.open("./data/#{config['summoner_name']}matches.json", 'w') do |f|
  f.write(matches.to_json)
end
