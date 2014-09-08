class NameCardBinder

  def initialize(num_pockets_per_page)
    @num_pockets_per_page = num_pockets_per_page
  end

  def card_number_behind(card_number)
    array_of_card_numbers = range_of_card_numbers(page_number(card_number)).to_a
    array_of_card_numbers.reverse[array_of_card_numbers.index(card_number)]
  end

  private

    def page_number(card_number)
      (card_number - 1) / (@num_pockets_per_page * 2) + 1
    end

    def range_of_card_numbers(page_number)
      number_from = (page_number - 1) * (@num_pockets_per_page * 2) + 1
      number_to   = number_from + @num_pockets_per_page * 2 - 1
      number_from .. number_to
    end
end


if __FILE__ == $0
  num_pockets_per_page, card_number = gets.split.map(&:to_i)

  puts NameCardBinder.new(num_pockets_per_page).card_number_behind(card_number)
end
