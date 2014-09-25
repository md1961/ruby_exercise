class CharHistogram

  def initialize(str)
    @str = str
  end

  def print_histogram
    h_count = count_chars

    ('a' .. 'z').to_a.each do |char|
      puts "#{char} #{h_count[char]}"
    end
  end

  def count_chars
    h_count = Hash.new(0)
    until @str.empty?
      if @str =~ /\A\)/
        advance_by(1)
        return h_count
      end

      count = 1
      if @str =~ /\A(\d+)/
        strCount = Regexp.last_match[1]
        count = Integer(strCount)
        advance_by(strCount.size)
      end

      if @str =~ /\A([a-z])/
        char = Regexp.last_match[1]
        advance_by(1)
        h_count[char] += count
      elsif @str =~ /\A\(/
        advance_by(1)
        count_chars.each do |char, freq|
          h_count[char] += freq * count
        end
      end
    end

    return h_count
  end

  private

    def advance_by(length)
      @str = @str[length, @str.size]
    end
end


if __FILE__ == $0
  ch = CharHistogram.new(gets.chomp)
  ch.print_histogram
end
