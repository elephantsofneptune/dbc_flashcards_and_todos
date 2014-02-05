class Deck
  attr_reader :deck
  def initialize
    @deck = []
  end

  #shifts through the cards using iteration
  def shuffle!
    @deck.shuffle!
  end

  def next_card! 
    @deck.push(@deck.shift)
  end  

  def get_top_card
    @deck[0]
  end
end