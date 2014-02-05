require_relative 'flashcard'

class Deck
  attr_reader :cards

  def initialize(card_data)
    @cards = []
    import_deck(card_data[:filename]) if card_data[:filename]
    create_deck(card_data[:card_array]) if card_data[:card_array]
  end

  def sample
    pulled_card = @cards.sample
    @cards -= [pulled_card]
    return pulled_card
  end

  def out_of_cards?
    @cards.empty?
  end

  private

  def create_deck(card_array)
    @cards = card_array
  end

  def import_deck(file)
    deck_array = []
    File.open(file, 'r').each_line do |line|
      unless line == "\n"
        deck_array << line.chomp
      end
    end
    deck_array.each_slice(2) do |slice|
      @cards << FlashCard.new(slice.first, slice.last)
    end
  end
end




