require_relative 'card'

class Deck
  attr_reader :cards
  def initialize    
    @cards = []
    @discard_pile = []
  end

  def shuffle!
    @cards = @cards.shuffle
  end

  def add_card(card)
    @cards << card
  end

  def delete!(term)
    deleted_card = @cards.delete_if { |c| c.term == term }
    @discard_pile << deleted_card
  end

  def next_card
    popped_card = @cards.pop
    @discard_pile << popped_card
    popped_card
  end

  def most_attempts
    @discard_pile.sort_by {|card| card.attempts }.pop(3)
  end
end
