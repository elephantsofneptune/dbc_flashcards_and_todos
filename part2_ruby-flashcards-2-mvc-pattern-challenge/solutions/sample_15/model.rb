class Card
  attr_reader :definition, :answer
 
  def initialize definition, answer
    @definition = definition
    @answer = answer
  end
end
 
class Deck
  attr_reader :card_deck
 
  def initialize
    @card_deck = []
  end
 
  def next_card!
    card_deck.rotate!
  end
 
  def get_card
    card_deck[0]
  end
 
  def delete_card(card_index)
    card_deck.delete_at(card_index)
  end
 
  def print_deck
    card_deck.each {|card| puts "#{card_deck.index(card) + 1}. #{card.definition}, #{card.answer}"}
  end
 
  def add_card(card)
    card_deck << card
  end
 
  def shuffle
    card_deck.shuffle
  end
 
end
 
# my_deck = Deck.new
# card1 = Card.new("What is your name?","Sir Lancelot of Camelot")
# card2 = Card.new("What is your quest?","I seek the grail!")
# card3 = Card.new("What is your favorite color?","Yellow")
# p my_deck.add_card(card1)
# p my_deck.add_card(card2)
# p my_deck.add_card(card3)
# p card1.definition
# p my_deck.shuffle
# p my_deck.next_card!
# p my_deck
# p my_deck.get_card
# p my_deck.delete_card(card1)
# p my_deck.get_card