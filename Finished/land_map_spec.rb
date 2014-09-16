require_relative 'land_map'

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

      it { is_expected.to eq 3 }
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

      it { is_expected.to eq 5 }
    end

    context '1 x 1, no land' do
      let(:land_matrix) {
        [
          %w(0),
        ]
      }

      it { is_expected.to eq 0 }
    end

    context '1 x 1, land' do
      let(:land_matrix) {
        [
          %w(1),
        ]
      }

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 0 }
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

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 1 }
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

      it { is_expected.to eq 18 }
    end

    context 'very large (1000 x 1000)' do
      let(:land_matrix) {
        [
          %w(1) * 1000,
        ] * 1000
      }

      it { is_expected.to eq 1 }
    end
  end
end
