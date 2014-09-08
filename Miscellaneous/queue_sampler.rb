#! /usr/local/bin/ruby

class QueueSampler

  def initialize(output_queue)
    @output_queue = output_queue

    @random = Random.new
  end

  def sample
    @output_queue.reset

    value_sampled = nil
    count = 0
    loop do
      value = @output_queue.deque
      count += 1
      break unless value
      value_sampled = value if @random.rand(count) == 0
    end

    value_sampled
  end
end


class OutputQueue

  def initialize(initial_values)
    @values = initial_values
    @index = 0
  end

  def deque
    retval = @values[@index]
    @index += 1
    retval
  end

  def reset
    @index = 0
  end
end


NUM_TRIES = 100000

VALUES = %w(a b c d e)

if __FILE__ == $0
  output_queue = OutputQueue.new(VALUES)
  queue_sample = QueueSampler.new(output_queue)

  h_counts = {}
  NUM_TRIES.times do
    value_sampled = queue_sample.sample
    count = h_counts[value_sampled] || 0
    h_counts[value_sampled] = count + 1
  end

  VALUES.each do |value|
    puts format("%s: %4d (%4.1f%%)", value, h_counts[value], h_counts[value] * 100.0 / NUM_TRIES)
  end
end

