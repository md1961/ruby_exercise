require_relative 'reversi'

describe Reversi do
  describe '#judge' do
    subject {
      reversi = Reversi.new
      moves.each do |move|
        reversi.move(*move)
      end
      reversi.judge
    }

    context 'Full moves' do
      let(:moves) {
        [
          ['B', 6, 5], ['W', 4, 6], ['B', 3, 4], ['W', 4, 3], ['B', 3, 5],
          ['W', 6, 6], ['B', 5, 6], ['W', 2, 6], ['B', 2, 5], ['W', 1, 6],
          ['B', 2, 4], ['W', 7, 6], ['B', 7, 5], ['W', 6, 4], ['B', 5, 3],
          ['W', 6, 3], ['B', 6, 2], ['W', 4, 2], ['B', 3, 2], ['W', 2, 3],
          ['B', 3, 6], ['W', 3, 7], ['B', 4, 7], ['W', 5, 7], ['B', 7, 7],
          ['W', 6, 7], ['B', 5, 8], ['W', 4, 8], ['B', 3, 8], ['W', 2, 8],
          ['B', 2, 7], ['W', 1, 7], ['B', 1, 8], ['W', 7, 8], ['B', 6, 8],
          ['W', 8, 7], ['B', 8, 6], ['W', 8, 4], ['B', 8, 5], ['W', 8, 8],
          ['B', 8, 3], ['W', 5, 2], ['B', 3, 3], ['W', 7, 4], ['B', 7, 3],
          ['W', 7, 2], ['B', 8, 2], ['W', 7, 1], ['B', 8, 1], ['W', 2, 2],
          ['B', 1, 5], ['W', 1, 4], ['B', 1, 3], ['W', 1, 2], ['B', 6, 1],
          ['W', 5, 1], ['B', 4, 1], ['W', 3, 1], ['B', 2, 1], ['W', 1, 1],
        ]
      }

      it { is_expected.to eq '38-26 The black won!' }
    end

    context 'One-sided' do
      let(:moves) {
        [
          ['B', 4, 3], ['W', 5, 3], ['B', 6, 3], ['W', 3, 3], ['B', 3, 4],
          ['W', 3, 5], ['B', 4, 6], ['W', 7, 3], ['B', 6, 5], ['W', 7, 5],
          ['B', 5, 6], ['W', 5, 7], ['B', 6, 4], ['W', 7, 4],
        ]
      }

      it { is_expected.to eq '00-18 The white won!' }
    end
  end
end
