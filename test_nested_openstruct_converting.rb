#!/usr/bin/env ruby
require 'json'
require 'recursive-open-struct'
single_hash = {
    id: 'id1',
    description: 'description',
    nestedHash: {
        id: 'id',
        status: 'DISABLE',
        description: 'description for nested hash',
    },
    nestedHash: {
        id: 'id',
        status: 'ACTIVE',
        description: 'description for nested hash',
    },
    nestedHash: {
        id: 'id',
        status: 'ACTIVE',
        description: 'description for nested hash',
    }
}

hash_list = { items:[] }

(1..1000).each do
    hash_list[:items].push(single_hash)
end

puts "List size: #{hash_list[:items].size}"

def to_recursive_ostruct(hash)
    OpenStruct.new(hash.each_with_object({}) do |(key, val), memo|
       	memo[key] = val.is_a?(Hash) ? to_recursive_ostruct(val) : val
   	end)
end

t = Time.new
to_recursive_ostruct(hash_list)
puts "recursive convert time: #{Time.new - t}"

t = Time.new
JSON.parse(hash_list.to_json, object_class: OpenStruct)
puts "JSON convert time: #{Time.new - t}"

t = Time.new
RecursiveOpenStruct.new(hash_list, recurse_over_arrays: true)
puts "Gem convert time: #{Time.new - t}"

# puts RecursiveOpenStruct.new(hash_list, recurse_over_arrays: true).items[0].id
# puts to_recursive_ostruct(hash_list).items[0].id
# puts JSON.parse(hash_list.to_json, object_class: OpenStruct).items[0].id
