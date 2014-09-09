class PaizaBowl

  def initialize(num_frames, num_pins)
    @num_frames = num_frames
    @num_pins   = num_pins

    @pins = Array.new(@num_frames + 1)  # Use it with an origin of 1
    @frame = 1
  end

  def throw_all(array_of_npins)
    loop do
      if final_frame?(@frame)
        throw_one(*array_of_npins)
      else
        npins = array_of_npins.shift
        if strike?([npins])
          throw_one(npins)
        else
          throw_one(npins, array_of_npins.shift)
        end
      end

      break if final_frame?(@frame)

      @frame += 1
    end
  end

  def throw_one(*array_of_npins)
    raise ArgumentError, "#{array_of_npins.inspect}" if illegal_throw_one?(array_of_npins)

    record(array_of_npins)
  end

  def total_score
    calculate_score
    @scores.compact.inject(&:+)
  end

  private

    def final_frame?(frame)
      frame == @num_frames
    end

    def strike?(array_of_npins)
      array_of_npins[0] == @num_pins
    end

    def spare?(array_of_npins)
      array_of_npins.size >= 2 && array_of_npins[0] + array_of_npins[1] == @num_pins
    end

    def illegal_throw_one?(array_of_npins)
      array_of_npins.size > 3 || \
      array_of_npins.any? { |npins| npins > @num_pins } || \
      array_of_npins.size <= 2 && array_of_npins.inject(&:+) > @num_pins || \
      array_of_npins.size == 1 && array_of_npins.first != @num_pins
    end

    def record(array_of_npins)
      @pins[@frame] = array_of_npins
    end

    def calculate_score
      @scores = @pins.map { |pin| pin && pin.inject(&:+) }
      1.upto(@num_frames) do |frame|
        add_bonus_for(frame)
      end
    end

    def add_bonus_for(frame)
      if final_frame?(frame)
        add_bonus_for_final_frame
      else
        pins_after = @pins[frame + 1, @pins.size].flatten
        if spare?(@pins[frame])
          @scores[frame] += pins_after[0]
        elsif strike?(@pins[frame])
          @scores[frame] += pins_after[0] + pins_after[1]
        end
      end
    end

    def add_bonus_for_final_frame
      frame = @num_frames
      pins = @pins[frame]
      if spare?(pins)
        @scores[frame] += pins[2]
      elsif strike?(pins)
        @scores[frame] += pins[1] + pins[2]
        if strike?(pins[1, 1])
          @scores[frame] += pins[2]
        end
      end
    end
end


if __FILE__ == $0
  num_frames, num_pins, num_throws = gets.split.map(&:to_i)
  array_of_npins = gets.split.map(&:to_i)

  pb = PaizaBowl.new(num_frames, num_pins)
  pb.throw_all(array_of_npins)
  puts pb.total_score
end
