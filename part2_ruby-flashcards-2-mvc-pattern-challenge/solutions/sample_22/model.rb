class Deck

  attr_reader :cards, :wrong_cards

  def initialize(flashcards)
    @cards = []
    @wrong_cards = []
    create_deck(flashcards)
    shuffle
  end

  def create_deck(flashcards)
    flashcards.each { |defn_and_term| @cards << Card.new(defn_and_term) }
  end

  def shuffle
    @cards.shuffle!
  end

  def build_wrong_deck(card)
    unless card.times_guessed < 3 || @wrong_cards.include?(card)
      @wrong_cards << card
    end
  end

  def remove_wrong_cards
    @cards = @wrong_cards.dup
    @wrong_cards = []
  end

  def reset_guesses
    @wrong_cards.each { |card| card.times_guessed = 0 }
  end

end

class Card

  attr_accessor :times_guessed
  attr_reader :definition, :term

  def initialize(args)
    @definition = args[:definition]
    @term = args[:term]
    @times_guessed = 0
  end

  def wrong_guess
    @times_guessed += 1
  end

end


