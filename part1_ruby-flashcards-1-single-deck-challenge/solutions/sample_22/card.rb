class Card
  attr_reader :definition, :answer
  def initialize(definition, answer)
    @definition = definition
    @answer = answer
  end
end

class Deck
  def initialize(filename)
    @file = filename
    @the_deck = []
    make_deck(@file)
  end

  def top_card
    current_card = @the_deck.shift
    @the_deck << current_card
    current_card
  end

  def shuffle!
    @the_deck.shuffle!
  end

  private

  def make_deck(filename)
    deck = IO.readlines(filename) do |line|
      line
    end
    deck.map! { |line| line.strip }
    deck.each { |line| deck.delete(line) if line == ''}
    make_cards(deck)
  end

  def make_cards(deck)
    deck.each_slice(2) { |a| @the_deck << Card.new(a[0],a[1]) }
  end
end
