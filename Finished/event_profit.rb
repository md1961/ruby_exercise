class EventProfit

  def initialize
    @events = []
  end

  def add_event(*profits)
    @events << Event.new(*profits)
  end

  def max_profit
    @events.map(&:total_profit).select { |profit| profit > 0 }.inject(&:+) || 0
  end

  class Event

    def initialize(*profits)
      @profits = profits
    end

    def total_profit
      @profits.inject(&:+)
    end
  end
end


if __FILE__ == $0
  num_fans, num_events = gets.split.map(&:to_i)
  ep = EventProfit.new

  if num_fans > 0
    num_events.times do
      ep.add_event(*(gets.split.map(&:to_i)))
    end
  end

  puts ep.max_profit
end
