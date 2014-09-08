require 'set'

class WordSnake
  attr_reader :words

  def initialize(word_or_words)
    @words = Array(word_or_words)
  end

  def size
    costs = words[0].size
    0.upto(words.size - 1 - 1) do |i|
      costs += cost_to_concatenate(last_word_for_concatenate(words[0 .. i]), words[i + 1])
    end
    costs
  end

  def cost_to_append(other)
    cost_to_concatenate(last_word_for_concatenate(self.words), other.words.first)
  end

  def +(other)
    WordSnake.new(self.words + other.words)
  end

  def eql?(other)
    other && self.words == other.words
  end

  def hash
    words.hash
  end

  def to_s
    words.join(',')
  end

    private

      def last_word_for_concatenate(words)
        (words.size - 1).downto(1) do |i|
          return words[i] unless words[i - 1].include?(words[i])
        end
        words[0]
      end

      def cost_to_concatenate(word_before, word_after)
        return 0 if word_before.include?(word_after)

        max_wrap = [word_before, word_after].map(&:size).min
        max_wrap.downto(1) do |n_wrap|
          return word_after.size - n_wrap if word_before[-n_wrap .. -1] == word_after[0 .. n_wrap - 1]
        end
        word_after.size
      end
end

class ShortestWordSnakeCreator

  def initialize(words)
    @initial_word_snakes = words.map { |word| WordSnake.new(word) }
  end

  def list_combinations(max_cost = 2)
    all_combinations(@initial_word_snakes).each do |word_snake_before, word_snake_after|
      cost = word_snake_before.cost_to_append(word_snake_after)
      puts "#{word_snake_before},#{word_snake_after} : #{cost}" if cost <= max_cost
    end
  end

  def solve(num_tries = 10)
    word_snakes = Set.new
    num_tries.times do
      word_snakes << combine_into_one_snake(@initial_word_snakes)
    end

    min_size = word_snakes.map(&:size).min

    h_size_and_count = Hash.new(0)
    word_snakes.each do |word_snake|
      puts "#{word_snake} : #{word_snake.size}" if word_snake.size == min_size
      h_size_and_count[word_snake.size] += 1
    end

    puts
    h_size_and_count.keys.sort.each do |size|
      puts format("%3d : %6d", size, h_size_and_count[size])
    end
  end

  private

    def all_combinations(word_snakes)
      retval = []
      word_snakes.each do |word_snake_before|
        word_snakes.each do |word_snake_after|
          next if word_snake_before == word_snake_after
          retval << [word_snake_before, word_snake_after]
        end
      end

      retval
    end

    def combine_into_one_snake(word_snakes)
      if word_snakes.size == 2
        return word_snakes[0].cost_to_append(word_snakes[1]) <= word_snakes[1].cost_to_append(word_snakes[0]) \
                  ? word_snakes[0] + word_snakes[1] \
                  : word_snakes[1] + word_snakes[0]
      end

      all_combinations = all_combinations(word_snakes)
      min_cost = all_combinations.map { |word_snake_before, word_snake_after|
        word_snake_before.cost_to_append(word_snake_after)
      }.min
      combinations_with_min_cost = all_combinations.select { |combination|
        combination[0].cost_to_append(combination[1]) == min_cost
      }
      combination_with_min_cost = combinations_with_min_cost.sample
      rest_of_word_snakes = word_snakes - [combination_with_min_cost[0], combination_with_min_cost[1]]
      combine_into_one_snake(rest_of_word_snakes + [combination_with_min_cost[0] + combination_with_min_cost[1]])
    end
end


WORDS = %w(subway dentist wayward highway terrible english less blessed warden rib stash shunt hunter)
# ==> 'subwaywardenglishunterriblessedentistashighway' (size = 46)

WORDS_IN_SHORTEST_ORDER = %w(subway wayward warden english shunt hunter terrible rib blessed less dentist stash highway)

if __FILE__ == $0
=begin
  word_snakes = WORDS_IN_SHORTEST_ORDER.map { |word| WordSnake.new(word) }
  the_word_snake = word_snakes.inject(&:+)
  puts "#{the_word_snake} : size = #{the_word_snake.size}"
=end

  ShortestWordSnakeCreator.new(WORDS).solve(100)
end
