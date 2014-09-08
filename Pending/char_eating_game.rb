class CharEatingGame

  def initialize(decks, hand)
    @initial_status = CardStatus.new(decks, hand)
  end

  def solve
    min_draws(@initial_status)
  end

  def min_draws(status)
    nums_draws = []
    status.next_statuses.each do |next_status|
      if next_status.finish?
        nums_draws << @initial_status.total_cards_in_decks - next_status.total_cards_in_decks
      else
        nums_draws << min_draws(next_status)
      end
    end

    nums_draws.compact.min
  end

  private

    def index_and_num_to_draw(status)
      nums_draws = status.array_of_num_draws_to_eat_one
      min_num_draws = nums_draws.compact.min
      index = nums_draws.index { |num_draws| num_draws == min_num_draws }
      [index, min_num_draws]
    end

  class CardStatus

    def initialize(decks, hand)
      @decks = decks
      @hand = hand
    end

    def finish?
      @hand.size == 0
    end

    def total_cards_in_decks
      @decks.map(&:size).inject(&:+)
    end

    def array_of_num_draws_to_eat_one
      @decks.map { |deck| n = deck.index(@hand[0]); n && n + 1 }
    end

    def next_status(index_deck, num_draws)
      deck = @decks[index_deck]
      draws = deck[0, num_draws]
      deck_after_draw = deck[num_draws, deck.size]
      hand = @hand[1, @hand.size] if draws.include?(@hand[0])
      new_decks = @decks.dup
      new_decks[index_deck] = deck_after_draw
      CardStatus.new(new_decks, hand)
    end

    def next_statuses
      statuses = []
      array_of_num_draws_to_eat_one.each_with_index do |num_draws, index|
        next unless num_draws
        statuses << next_status(index, num_draws)
      end
      statuses
    end

    def dup
      CardStatus.new(@decks.dup, @hand.dup)
    end

    def to_s
      "#{@decks.join(' ')} : #{@hand}"
    end
  end
end

DATA = [
  %w(
    qpmnuthkahg
    uyianhjak
    jta
  ),
# 14
  %w(
    zclgthiu
    nyxomiaskq
    giku
  ),
# 17
  %w(
    ababababababababababababababababab
    bababababababababababababababac
    abababababababababababababababababababababababababc
  ),
# 51
]

if __FILE__ == $0
  DATA.each do |data|
    ceg = CharEatingGame.new([data[0], data[1]], data[2])
    puts ceg.solve
  end
end
