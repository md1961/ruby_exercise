require_relative 'maze'

RSpec.describe 'maze' do

  describe '#shortest_path' do
    subject {
      maze = Maze.new(grids)
      maze.shortest_path
    }

    context '4 x 5' do
      let(:grids) {
        [
          %w(0 s 0 1),
          %w(0 0 1 0),
          %w(0 1 1 0),
          %w(0 0 1 g),
          %w(0 0 0 0),
        ]
      }

      it { is_expected.to eq 9 }
    end

    context '4 x 4, unsolvable' do
      let(:grids) {
        [
          %w(0 s 0 1),
          %w(1 0 0 0),
          %w(0 1 1 1),
          %w(0 0 0 g),
        ]
      }

      it { is_expected.to eq 'Fail' }
    end

    context '6 x 7' do
      let(:grids) {
        [
          %w(0 s 0 1 0 0),
          %w(0 1 0 0 0 0),
          %w(0 0 1 1 1 0),
          %w(0 0 1 g 0 1),
          %w(0 0 0 1 0 0),
          %w(0 0 0 1 1 0),
          %w(0 0 0 0 0 0),
        ]
      }

      it { is_expected.to eq 17 }
    end

    context 'easiest' do
      let(:grids) {
        [
          %w(s),
          %w(g),
        ]
      }

      it { is_expected.to eq 1 }
    end
  end
end
