require_relative 'card'

class Deck
  def initialize
    @deck = []
    @file = File.open('flashcards.txt', 'r')
    parse
  end

  def parse
    contents_array = @file.read.split("\n \n").map! { |string| string.split("\n") }
    create_deck(contents_array)
  end

  def create_deck(contents_array)
    contents_array.each { |card| @deck << Card.new(card)}
  end

  def pick_card
    @deck.shuffle!.pop
  end

end

deck = Deck.new