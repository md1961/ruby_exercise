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


describe LandMap do
  describe '#initialize' do
    context 'inconsistent matrix argument' do
      let(:land_matrix) {
        [
          %w(1 1 0),
          %w(0 1 1),
          %w(0 0),
          %w(0 1 0),
        ]
      }

      it { expect { LandMap.new(land_matrix) }.to raise_error(ArgumentError) }
    end
  end

  describe '#num_islands' do
    subject { LandMap.new(land_matrix).num_islands }

    context 'pattern 1' do
      let(:land_matrix) {
        [
          %w(0 1 1 0),
          %w(1 0 1 0),
          %w(1 0 0 0),
          %w(0 0 1 1),
          %w(0 1 1 1),
        ]
      }

      it { is_expected.to be 3 }
    end

    context 'pattern 2' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1),
          %w(1 0 1 0 0 0),
          %w(1 0 1 0 1 1),
          %w(0 1 0 0 0 1),
          %w(1 0 1 1 1 1),
          %w(0 1 0 0 0 0),
        ]
      }

      it { is_expected.to be 5 }
    end

    context '1 x 1, no land' do
      let(:land_matrix) {
        [
          %w(0),
        ]
      }

      it { is_expected.to be 0 }
    end

    context '1 x 1, land' do
      let(:land_matrix) {
        [
          %w(1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'big no land' do
      let(:land_matrix) {
        [
          %w(0 0 0 0 0 0),
          %w(0 0 0 0 0 0),
          %w(0 0 0 0 0 0),
          %w(0 0 0 0 0 0),
          %w(0 0 0 0 0 0),
          %w(0 0 0 0 0 0),
        ]
      }

      it { is_expected.to be 0 }
    end

    context 'big land' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1),
          %w(1 1 1 1 1 1),
          %w(1 1 1 1 1 1),
          %w(1 1 1 1 1 1),
          %w(1 1 1 1 1 1),
          %w(1 1 1 1 1 1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'ring island' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1),
          %w(1 0 0 0 0 1),
          %w(1 0 0 0 0 1),
          %w(1 0 0 0 0 1),
          %w(1 0 0 0 0 1),
          %w(1 1 1 1 1 1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'six-shape island' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1 1),
          %w(1 0 0 0 0 0 0),
          %w(1 0 0 0 0 0 0),
          %w(1 0 0 0 0 0 0),
          %w(1 1 1 1 1 1 1),
          %w(1 0 0 0 0 0 1),
          %w(1 0 0 0 0 0 1),
          %w(1 0 0 0 0 0 1),
          %w(1 1 1 1 1 1 1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'snake-like island' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1 1),
          %w(0 0 0 0 0 0 1),
          %w(1 1 1 1 1 1 1),
          %w(1 0 0 0 0 0 0),
          %w(1 1 1 1 1 1 1),
          %w(0 0 0 0 0 0 1),
          %w(1 1 1 1 1 1 1),
          %w(1 0 0 0 0 0 0),
          %w(1 1 1 1 1 1 1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'grid patter' do
      let(:land_matrix) {
        [
          %w(1 1 1 1 1 1 1),
          %w(1 0 1 0 1 0 1),
          %w(1 1 1 1 1 1 1),
          %w(1 0 1 0 1 0 1),
          %w(1 1 1 1 1 1 1),
          %w(1 0 1 0 1 0 1),
          %w(1 1 1 1 1 1 1),
          %w(1 0 1 0 1 0 1),
          %w(1 1 1 1 1 1 1),
        ]
      }

      it { is_expected.to be 1 }
    end

    context 'alternating pattern' do
      let(:land_matrix) {
        [
          %w(1 0 1 0 1 0),
          %w(0 1 0 1 0 1),
          %w(1 0 1 0 1 0),
          %w(0 1 0 1 0 1),
          %w(1 0 1 0 1 0),
          %w(0 1 0 1 0 1),
        ]
      }

      it { is_expected.to be 18 }
    end
  end
end
