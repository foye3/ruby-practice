# frozen_string_literal: true

require 'rumouse'

mouse = RuMouse.new

puts 'Input number of minutes'
limit = gets.chomp

counter = 0
loop do
  mouse.click 10, 10
  counter += 1
  puts "clicker done #{counter}"
  sleep(60)
  break if counter > limit
end
