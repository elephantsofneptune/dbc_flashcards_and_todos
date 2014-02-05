require 'csv'
require "./model.rb"

class DatabaseReader
  attr_reader :file

  def initialize(file)
    @file = file
    load_file
  end

  def load_file
    @info = CSV.read(@file)
    parse_csv_info
  end

  def parse_csv_info
    # create definitions array
    # create answers array
    @card_array = @info.map do |card|
      Card.new(card[0], card[1])
    end
  end

  def populate(deck)
    @card_array.each {|card| deck.add_card(card)}
  end
  

  def save_csv(deck)
    CSV.open(@file, "w") do |line|
      deck.each do |card|
        line << [card.definition, card.answer]
      end
    end
  end
end


# #myDeck = Deck.new
# myDB = DatabaseReader.new('flashcards.csv')
# deck_of_cards = Deck.new
# myDB.populate(deck_of_cards)
# puts deck_of_cards.inspect
# myDB.save_csv(deck_of_cards.card_deck)
