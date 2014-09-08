require 'set'

class SpiralMovers
  attr_reader :t

  def initialize(initial_coordinates)
    @movers = initial_coordinates.map { |x, y| Mover.new(Point.new(x, y)) }
    @points_occupied = Set.new

    record_positions
    @t = 0
  end

  def move
    loop do
      @movers.each { |mover| mover.move }

      remove_movers_moving_into_occupied_point
      remove_movers_colliding_each_other

      break if @movers.empty?

      record_positions
      @t += 1
    end
  end

  private

    def remove_movers_moving_into_occupied_point
      @movers.delete_if { |mover| @points_occupied.include?(mover.position) }
    end

    def remove_movers_colliding_each_other
      return if @movers.size <= 1

      indexes_to_remove = []
      0.upto(@movers.size - 1 - 1).each do |i|
        (i + 1).upto(@movers.size - 1) do |j|
          indexes_to_remove << i << j if @movers[i].position == @movers[j].position
        end
      end
      indexes_to_remove.sort.reverse.each { |index| @movers.delete_at(index) }
    end

    def record_positions
      @movers.each { |mover| @points_occupied << mover.position }
    end

  class Point
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def move_by(dx, dy)
      Point.new(x + dx, y + dy)
    end

    def ==(other)
      self.x == other.x && self.y == other.y
    end

    def eql?(other)
      self.==(other)
    end

    def hash
      [x, y].hash
    end

    def to_s
      "(#{x},#{y})"
    end
  end

  class Mover

    def initialize(initial_point)
      @point = initial_point
      @spiral_movement = SpiralMovement.new
    end

    def position
      @point
    end

    def move
      @point = @point.move_by(*@spiral_movement.next_move)
    end

    def to_s
      "@#{@point}"
    end
  end

  #                   1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2
  # 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 ...
  #-------------------------------------------------------
  # R U L L D D R R R U U U L L L L D D D D R R R R R ...
  # 1 1 1 2 1 2 1 2 3 1 2 3 1 2 3 4 1 2 3 4 1 2 3 4 5 ...
  class SpiralMovement
    RIGHT = [ 1,  0]
    UP    = [ 0, -1]
    LEFT  = [-1,  0]
    DOWN  = [ 0,  1]

    def initialize
      @next_steps = [1, 1, 2, 2]

      @steps = 0
      @direction = RIGHT
    end

    def next_move
      if @steps == 0
        @steps = @next_steps.shift
        @next_steps << @steps + 2
      end
      @steps -= 1
      @direction.tap { change_direction if @steps == 0 }
    end

    DIRECTION_ORDERS = [RIGHT, UP, LEFT, DOWN, RIGHT]

    def change_direction
      index = DIRECTION_ORDERS.index(@direction) + 1
      @direction = DIRECTION_ORDERS[index]
    end
  end
end


if __FILE__ == $0
  num_movers = gets.to_i

  initial_coordinates = []
  num_movers.times do
    initial_coordinates << gets.split.map(&:to_i)
  end

  sm = SpiralMovers.new(initial_coordinates)
  sm.move
  puts sm.t
end
