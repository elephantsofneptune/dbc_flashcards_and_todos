require 'csv'

module DeckPopulator
  def populate_deck(csv_file)
    array_of_cards = []
    CSV.foreach(csv_file) do |term,definition|
      array_of_cards << Card.new({:term => term, :definition => definition})
    end
    array_of_cards
  end
end

module FindDecksInDirectory
  require 'pathname'
  def find_decks(deck_path)
    decks_to_play = []
    Pathname(deck_path).each_child {|f| decks_to_play << f.basename('.*')}
    decks_to_play
  end
end

class Card 

  attr_reader :definition, :term 

  def initialize(args)
    @definition = args.fetch(:definition)
    @term = args.fetch(:term)
  end

end

class CardDeck
  attr_reader :name, :deck, :current_card

  def initialize(args)
    @name = args.fetch(:deck_name)
    @deck = args.fetch(:card_array)
    @current_card = @deck.shift
  end

  def shuffle_deck
    @deck.shuffle
  end

  def all_terms_guessed
    @deck.empty? && @current_card == nil
  end

  def correct_answer(guess)
    guess == @current_card.term
  end

  def current_definition
    @current_card.definition
  end

  def current_term
    @current_card.term
  end

  def card_guessed_incorrectly
    @deck << @current_card
    @current_card = @deck.shift
  end

  def card_guessed_correctly
    @current_card = @deck.shift
  end
end

class DeckConstructor
  include DeckPopulator
  include FindDecksInDirectory
end

