# frozen_string_literal: true

require 'json'
require 'recursive-open-struct'

single_hash = {
  id: 'id1',
  description: 'description',
  nestedHash1: {
    id: 'id1',
    status: 'DISABLE',
    description: 'description for nested hash'
  },
  nestedHash2: {
    id: 'id2',
    status: 'ACTIVE',
    description: 'description for nested hash',
    nestedHash3: {
      id: 'id3',
      status: 'ACTIVE',
      description: 'description for nested hash'
    }
  }
}

hash_list = { items: [] }

10_000.times do
  hash_list[:items].push(single_hash)
end

puts "List size: #{hash_list[:items].size}"

def to_recursive_ostruct(hash)
  OpenStruct.new(hash.each_with_object({}) do |(key, val), memo|
                   memo[key] = val.is_a?(Hash) ? to_recursive_ostruct(val) : val
                 end)
end

t = Time.new
ob1 = to_recursive_ostruct(hash_list)
puts "recursive convert time: #{Time.new - t}"

t = Time.new
ob2 = JSON.parse(hash_list.to_json, object_class: OpenStruct)
puts "JSON convert time: #{Time.new - t}"

t = Time.new
ob3 = RecursiveOpenStruct.new(hash_list, recurse_over_arrays: true)
puts "Gem convert time: #{Time.new - t}"

puts ob1.items[0]
puts ob2.items[0]
puts ob3.items[0]
