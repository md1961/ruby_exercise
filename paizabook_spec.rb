require_relative 'paizabook'

RSpec.describe 'Paizabook' do

  describe '#related?' do
    let(:pb) { Paizabook.new }

    it 'pattern 1' do
      pb.add_relation(1, 2)
      pb.add_relation(1, 3)
      expect(pb.related?(3, 2)).to be_truthy
      expect(pb.related?(3, 4)).to be_falsey
      pb.add_relation(4, 5)
      expect(pb.related?(3, 5)).to be_falsey
      pb.add_relation(1, 4)
      expect(pb.related?(3, 5)).to be_truthy
    end

    it 'pattern 2' do
      pb.add_relation(3, 1)
      expect(pb.related?(2, 4)).to be_falsey
      expect(pb.related?(1, 2)).to be_falsey
      expect(pb.related?(1, 3)).to be_truthy
      expect(pb.related?(3, 2)).to be_falsey
      pb.add_relation(1, 4)
      expect(pb.related?(2, 3)).to be_falsey
      pb.add_relation(1, 2)
      expect(pb.related?(2, 4)).to be_truthy
    end

    it 'pattern 3' do
      expect(pb.related?(1, 10)).to be_falsey
      pb.add_relation(9, 7)
      expect(pb.related?(2, 7)).to be_falsey
      pb.add_relation(6, 8)
      pb.add_relation(5, 3)
      pb.add_relation(2, 9)
      expect(pb.related?(3, 8)).to be_falsey
      pb.add_relation(8, 4)
      pb.add_relation(10, 5)
      expect(pb.related?(5, 7)).to be_falsey
      expect(pb.related?(3, 4)).to be_falsey
      expect(pb.related?(9, 10)).to be_falsey
      pb.add_relation(4, 1)
      pb.add_relation(2, 6)
      pb.add_relation(10, 6)
      expect(pb.related?(8, 3)).to be_truthy
    end
  end
end
