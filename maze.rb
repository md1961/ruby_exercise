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

  def shortest_path
    starts = locate(START)
    raise ArgumentError, "No start found" if starts.empty?
    raise ArgumentError, "Multiple starts" if starts.size > 1

    i_col_start, i_row_start = starts.first
    is_goal_found = mark_distance(i_col_start, i_row_start)
    return 1 if is_goal_found

    is_goal_found = false
    distance = 1
    loop do
      coordinates = locate(distance)
      break if coordinates.empty?

      coordinates.each do |i_col, i_row|
        is_goal_found = mark_distance(i_col, i_row)
        break if is_goal_found
      end
      
      distance += 1
      break if is_goal_found
    end

    is_goal_found ? distance : 'Fail'
  end

  def to_s
    @grids.map { |row| row.join }.join("\n")
  end

  private

    def mark_distance(i_col, i_row)
      origin = @grids[i_row][i_col]
      if origin == GOAL || origin == WALL || origin == PATH
        raise RuntimeError, "Illegal '#{origin}' @(#{i_col}, #{i_row})"
      end

      distance = origin == START ? 1 : origin + 1
      [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |d_col, d_row|
        adjacent = @grids[i_row + d_row][i_col + d_col]
        if adjacent == GOAL
          return true
        elsif adjacent == PATH || adjacent.to_i > distance
          @grids[i_row + d_row][i_col + d_col] = distance
        end
      end

      false
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
