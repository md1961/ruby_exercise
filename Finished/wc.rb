command = gets.chomp
num_lines = gets.to_i

lines = []
num_lines.times do
  lines << gets
end

words = lines.join.split(/\s+/).delete_if(&:empty?)

puts words.size      if command.include?('w')
puts lines.join.size if command.include?('c')
