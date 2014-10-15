require_relative 'char_histogram'

RSpec.describe 'char_histogram' do

  describe '#count_chars' do
    subject {
      ch = CharHistogram.new(str)
      ch.count_chars
    }

    context 'having every alphabets' do
      let(:str) { 'abcdefg10h12(ij2(3k))l9mnop4(3(2(6(qq)r)s5tu)7v5w)x15(yz)' }
      let(:expected) {
        stringify_keys({
          a: 1,
          b: 1,
          c: 1,
          d: 1,
          e: 1,
          f: 1,
          g: 1,
          h: 10,
          i: 12,
          j: 12,
          k: 72,
          l: 1,
          m: 9,
          n: 1,
          o: 1,
          p: 1,
          q: 288,
          r: 24,
          s: 12,
          t: 60,
          u: 12,
          v: 28,
          w: 20,
          x: 1,
          y: 15,
          z: 15,
        })
      }

      it { is_expected.to eq expected }
    end

    context 'deeply nested with very large counts' do
      let(:str) { '10000(10000(10000(2000(ab)500(dz)c200h)2mu3000(fpr)))' }
      let(:expected) {
        stringify_keys({
          a: 2000000000000000,
          b: 2000000000000000,
          c: 1000000000000,
          d: 500000000000000,
          f: 300000000000,
          h: 200000000000000,
          m: 200000000,
          p: 300000000000,
          r: 300000000000,
          u: 100000000,
          z: 500000000000000,
        })
      }

      it { is_expected.to eq expected }
    end
  end

  def stringify_keys(hash)
    Hash[hash.map { |k, v| [k.to_s, v] }]
  end
end
