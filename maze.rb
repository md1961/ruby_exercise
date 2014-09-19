class Maze

  START = 's'
  GOAL  = 'g'
  PATH  = '.'
  WALL  = 'X'
  
  WALL_INPUT = '1'
  PATH_INPUT = '0'

  def initialize(grids)
    @grids = grids.map { |row| row.map { |col| convert_grid_value(col) } }

    @num_rows = @grids.size
    @num_cols = @grids.first.size

    @grids = @grids.map { |row| [WALL] + row + [WALL] }
    @grids.unshift([WALL] * (@num_cols + 2))
    @grids.push(   [WALL] * (@num_cols + 2))
  end

  MESSAGE_WHEN_FAIL = 'Fail'

  def shortest_path
    starts = locate(START)
    raise ArgumentError, "No start found" if starts.empty?
    raise ArgumentError, "Multiple starts" if starts.size > 1

    i_col_start, i_row_start = starts.first
    marked_coordinates = mark_distance(i_col_start, i_row_start)
    return 1 if marked_coordinates == GOAL
    return MESSAGE_WHEN_FAIL if marked_coordinates.empty?

    is_goal_found = false
    distance = 1
    loop do
      next_coordinates = []
      marked_coordinates.each do |i_col, i_row|
        coordinates = mark_distance(i_col, i_row)
        if coordinates == GOAL
          is_goal_found = true
          break
        end
        next_coordinates.concat(coordinates)
      end
      break if marked_coordinates.empty?
      
      distance += 1
      break if is_goal_found
      marked_coordinates = next_coordinates
    end

    is_goal_found ? distance : MESSAGE_WHEN_FAIL
  end

  def to_s
    @grids.map { |row| row.join }.join("\n")
  end

  private

    def mark_distance(i_col, i_row)
      origin = @grids[i_row][i_col]
      if origin == GOAL || origin == WALL || origin == PATH
        raise RuntimeError, "Illegal mark_distance() call with '#{origin}' @(#{i_col}, #{i_row})"
      end

      marked_coordinates = []
      distance = origin == START ? 1 : origin + 1
      [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |d_col, d_row|
        _i_col = i_col + d_col
        _i_row = i_row + d_row
        adjacent = @grids[_i_row][_i_col]
        if adjacent == GOAL
          return GOAL
        elsif adjacent == PATH
          @grids[_i_row][_i_col] = distance
          marked_coordinates << [_i_col, _i_row]
        end
      end

      marked_coordinates
    end

    def locate(value)
      retval = []
      1.upto(@num_rows) do |i_row|
        1.upto(@num_cols) do |i_col|
          if @grids[i_row][i_col] == value
            retval << [i_col, i_row]
          end
        end
      end

      retval
    end

    def convert_grid_value(value)
      if value == WALL_INPUT
        WALL
      elsif value == PATH_INPUT
        PATH
      else
        value 
      end
    end
end


if __FILE__ == $0
  num_cols, num_rows = gets.split.map(&:to_i)

  grids = Array.new(num_rows)
  num_rows.times do |index_row|
    grids[index_row] = gets.chomp.split
  end

  maze = Maze.new(grids)
  puts maze.shortest_path
end
