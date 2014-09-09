require_relative 'paiza_bowl'

describe PaizaBowl do
  describe '#total_score' do
    subject {
      pb = PaizaBowl.new(num_frames, num_pins)
      pb.throw_all(array_of_npins)
      pb.total_score
    }

    context '10-pin game' do
      let(:num_frames) { 10 }
      let(:num_pins) { 10 }
      let(:array_of_npins) {
        %w(3 4 G 1 8 2 6 2 10 2 7 G 10 10 10 9 1 3).map(&:to_i)
      }

      it { is_expected.to be 145 }
    end

    context '5-pin game' do
      let(:num_frames) { 15 }
      let(:num_pins) { 5 }
      let(:array_of_npins) {
        %w(5 5 5 4 G 1 G 5 3 2 1 4 4 G G 1 5 5 5 2 1 5 3 1).map(&:to_i)
      }

      it { is_expected.to be 124 }
    end
  end
end
