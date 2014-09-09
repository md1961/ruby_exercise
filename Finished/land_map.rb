class LandMap

  LAND    = 'X'
  NO_LAND = '0'

  def initialize(land_matrix)
    @land_matrix = land_matrix
    @n_rows = land_matrix.size
    @n_cols = land_matrix.first.size
    raise ArgumentError unless land_matrix.map(&:size).all? { |n| n == @n_cols }
    init_land_matrix
  end

    def init_land_matrix
      @land_matrix = @land_matrix.map do |row|
        row_converted = row.map { |x| x == NO_LAND ? NO_LAND : LAND }
        [NO_LAND, row_converted, NO_LAND].flatten
      end
      @land_matrix.unshift([NO_LAND] * (@n_cols + 2))
      @land_matrix.push(   [NO_LAND] * (@n_cols + 2))
    end
    private :init_land_matrix

  def num_islands
    count_islands
  end

  private

    def count_islands
      seq_num = 1
      1.upto(@n_rows) do |i_row|
        1.upto(@n_cols) do |i_col|
          has_marked = mark_land(i_row, i_col, seq_num)
          seq_num += 1 if has_marked
        end
      end

      seq_num - 1
    end

    def mark_land(i_row, i_col, seq_num)
      return false if no_land?(i_row, i_col) || marked?(i_row, i_col)

      set_value(i_row, i_col, seq_num)

      mark_land(i_row - 1, i_col    , seq_num)
      mark_land(i_row    , i_col - 1, seq_num)
      mark_land(i_row + 1, i_col    , seq_num)
      mark_land(i_row    , i_col + 1, seq_num)

      true
    end

    def value_at(i_row, i_col)
      @land_matrix[i_row][i_col]
    end

    def set_value(i_row, i_col, value)
      @land_matrix[i_row][i_col] = value
    end

    def no_land?(i_row, i_col)
      value_at(i_row, i_col) == NO_LAND
    end

    def marked?(i_row, i_col)
      value_at(i_row, i_col).to_i > 0
    end
end


if __FILE__ == $0
  n_cols, n_rows = gets.split.map(&:to_i)
  land_matrix = []
  n_rows.times do
    land_matrix << gets.chomp.split
  end

  lm = LandMap.new(land_matrix)
  puts lm.num_islands
end
