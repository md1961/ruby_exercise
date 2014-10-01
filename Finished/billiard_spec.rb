require_relative 'billiard'

RSpec.describe 'Billiard' do

  let(:tolerance) { 1e-6 }

  describe '#shoot' do
    context 'Right in positive Y-direction back to the start' do
      let(:billiard) {
        width       = 100
        depth       = 100
        ball_radius = 2

        Billiard.new(width, depth, ball_radius)
      }

      let(:shoot_args) {
        x0          = 50
        y0          = 50
        theta0      = 90
        shot_length = 288

        [x0, y0, theta0, shot_length]
      }

      it 'returns the starting coordinates' do
        expect(billiard.shoot(*shoot_args)).to match [
          be_within(tolerance).of(50),
          be_within(tolerance).of(50),
        ]
      end
    end

    context '45 degree in X and Y positive direction' do
      let(:billiard) {
        width       = 127
        depth       = 254
        ball_radius = 3

        Billiard.new(width, depth, ball_radius)
      }

      let(:shoot_args) {
        x0          = 63
        y0          = 63
        theta0      = 45
        shot_length = 1000

        [x0, y0, theta0, shot_length]
      }

      it 'returns the coordinates with long decimal fractions' do
        expect(billiard.shoot(*shoot_args)).to match [
          be_within(tolerance).of(44.1067811865475),
          be_within(tolerance).of(227.893218813452),
        ]
      end
    end
  end
end
