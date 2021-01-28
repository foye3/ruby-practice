# frozen_string_literal: true

# Example Usage:
#   ruby mouse_clicker.rb 20
#   will click once every minute for 20 minutes

require 'rumouse'

mouse = RuMouse.new

limit = ARGV[0]
counter = 0
loop do
  mouse.click 10, 10
  counter += 1
  puts "clicker done #{counter}"
  sleep(60)
  break if counter >= limit
end
