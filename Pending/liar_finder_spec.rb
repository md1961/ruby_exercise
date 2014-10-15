require_relative 'liar_finder'

RSpec.describe 'LiarFinder' do

  describe '#judge' do
    subject {
      lf = LiarFinder.new(num_people)
      statements.each do |statement|
        lf.add_statement(statement)
      end

      lf.judge
    }

    context 'example 1' do
      let(:num_people) { 5 }
      let(:statements) {
        build_statements([
          [1, 3, true ],
          [2, 3, false],
          [5, 4, true ],
        ])
      }

      it { is_expected.to eq 3 }
    end

    context 'example 2' do
      let(:num_people) { 3 }
      let(:statements) {
        build_statements([
          [3, 2, false],
          [3, 1, false],
          [3, 2, true ],
        ])
      }

      it { is_expected.to eq -1 }
    end

    context 'example 2d' do
      let(:num_people) { 3 }
      let(:statements) {
        build_statements([
          [3, 2, false],
          [3, 1, false],
          [1, 1, false],
        ])
      }

      it { is_expected.to eq -1 }
    end

    context 'every five people said everybody are honest' do
      let(:num_people) { 5 }
      let(:statements) {
        build_statements([
          [1, 1, true],
          [1, 2, true],
          [1, 3, true],
          [1, 4, true],
          [1, 5, true],
          [2, 1, true],
          [2, 2, true],
          [2, 3, true],
          [2, 4, true],
          [2, 5, true],
          [3, 1, true],
          [3, 2, true],
          [3, 3, true],
          [3, 4, true],
          [3, 5, true],
          [4, 1, true],
          [4, 2, true],
          [4, 3, true],
          [4, 4, true],
          [4, 5, true],
          [5, 1, true],
          [5, 2, true],
          [5, 3, true],
          [5, 4, true],
          [5, 5, true],
        ])
      }

      it { is_expected.to eq 2 }
    end

    context 'every five people said everybody are liars' do
      let(:num_people) { 5 }
      let(:statements) {
        build_statements([
          [1, 2, false],
          [1, 3, false],
          [1, 4, false],
          [1, 5, false],
          [2, 1, false],
          [2, 3, false],
          [2, 4, false],
          [2, 5, false],
          [3, 1, false],
          [3, 2, false],
          [3, 4, false],
          [3, 5, false],
          [4, 1, false],
          [4, 2, false],
          [4, 3, false],
          [4, 5, false],
          [5, 1, false],
          [5, 2, false],
          [5, 3, false],
          [5, 4, false],
        ])
      }

      it { is_expected.to eq -1 }
    end

    context 'facts with same_kind? of true hard to merge' do
      let(:num_people) { 6 }
      let(:statements) {
        build_statements([
          [1, 2, true],
          [3, 4, true],
          [1, 3, true],
          [4, 5, true],
          [1, 5, true],
          [1, 6, true],
          [4, 6, true],
        ])
      }

      it { is_expected.to eq 2 }
    end

    context 'four different people' do
      let(:num_people) { 4 }
      let(:statements) {
        build_statements([
          [1, 2, false],
          [2, 1, false],
          [2, 3, false],
          [3, 2, false],
          [3, 4, false],
          [4, 3, false],
          [4, 1, false],
          [1, 4, false],
        ])
      }

      it { is_expected.to eq 2 }
    end

    context 'five people pattern 1' do
      let(:num_people) { 5 }
      let(:statements) {
        build_statements([
          [1, 2, false],
          [3, 4, true ],
          [5, 1, false],
        ])
      }

      it { is_expected.to eq 3 }
    end
  end

  private

    def build_statements(array_of_args)
      array_of_args.map { |args| build_statement(*args) }
    end

    # if is_honest is;
    #   true  : returns like "1 said 2 was an honest person."
    #   false : returns like "1 said 2 was a liar."
    def build_statement(stater, objective, is_honest)
      "#{stater} said #{objective} was #{is_honest ? 'an honest person' : 'a liar'}."
    end
end
