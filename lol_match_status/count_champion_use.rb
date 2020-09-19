# frozen_string_literal: true

require 'json'
require 'yaml'

config = YAML.load_file('./config.yml')
matches = JSON.parse(File.read("./data/#{config['summoner_name']}matches.json"))

puts "Total matches: #{matches.size}"

champions = JSON.parse(
  File.read("./data/constant/#{config['constant_version']}/champion.json")
)['data']

champions_hash = {}

champions.each do |key, val|
  champions_hash.merge!(val['key'] => { 'name' => key, 'count' => 0 })
end

matches.each do |m|
  champions_hash[(m['champion']).to_s]['count'] += 1
end

champions_hash = champions_hash.sort_by { |_k, v| -v['count'] }
champions_hash.each { |_k, v| puts v }
