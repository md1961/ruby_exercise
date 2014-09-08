class GalapagosMobileTyper
  HASH_KEYS = {
    '1' => '.@-_/:~1',
    '2' => 'abcABC2',
    '3' => 'defDEF3',
    '4' => 'ghiGHI4',
    '5' => 'jklJKL5',
    '6' => 'mnoMNO6',
    '7' => 'pqrsPQRS7',
    '8' => 'tuvTUV8',
    '9' => 'wxyzWXYZ9',
  }

  def interpret(s)
    prev_c = s[0]
    count = 0
    c_out = ''
    result = ''
    s.each_char do |c|
      if c == 'E' || c != prev_c
        result += c_out
        count = 0
        next if c == 'E'
      end

      count += 1
      c_out_string = HASH_KEYS[c]
      pos = count % c_out_string.length - 1
      c_out = c_out_string.slice(pos, 1)

      prev_c = c
    end

    result
  end
end


describe GalapagosMobileTyper do
  describe '#interpret' do
    subject { GalapagosMobileTyper.new.interpret(input) }

    context 'pattern #1' do
      let(:input) { '4444433555E5556661111999996667775553E' }
      it { is_expected.to eq 'Hello_World' }
    end

    context 'pattern #2' do
      let(:input) { '7244499992222222277777777E77726655E' }
      it { is_expected.to eq 'paizaSrank' }
    end
  end
end
