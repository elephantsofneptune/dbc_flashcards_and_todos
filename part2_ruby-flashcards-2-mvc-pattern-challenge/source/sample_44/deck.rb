class Deck
  attr_reader :card_deck

  def initialize
    @card_deck = []
  end

  #In controller add logic that quits when deck is empty
  def shuffle
    card_deck.shuffle
  end

  def empty?
    card_deck.empty?
  end

  def each_card
    self.shuffle.each do |card|
      yield card
    end
  end

  def <<(flash_card)
    card_deck << flash_card
  end
end

