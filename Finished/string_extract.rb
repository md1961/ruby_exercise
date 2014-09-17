start_tag, end_tag = gets.chomp.split
str_original = gets.chomp

outputs = []
pos = 0
loop do
  pos_start = str_original.index(start_tag, pos)
  break unless pos_start

  pos = pos_start + start_tag.size
  pos_end = str_original.index(end_tag, pos)
  break unless pos_end

  str_out = str_original[pos ... pos_end]
  puts str_out.empty? ? '<blank>' : str_out

  pos = pos_end + end_tag.size
end
