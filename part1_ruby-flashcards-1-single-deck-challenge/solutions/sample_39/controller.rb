# Main file for team copacetic's flashcards

require 'csv'
require_relative 'TextParser'
require_relative 'Card'
require_relative 'Deck'
require_relative 'View'

class Controller

  def initialize(file)
    @file=file
    @game_deck = Deck.new
  end

  #i:
  # conversion from array of hashes to created cards
  def card_factory(unformatted_cards)
    unformatted_cards.each do |hash|
      add_cards_to_deck(Card.new(hash))
    end 
  end
  #o: card objects as an array

  #i: the output from card factory
  def add_cards_to_deck(card)
    @game_deck.deck << card
  end
  #o:  push cards into the deck class

  def run
    #possible loop
    unformatted_cards = TextParser.run(@file)
    card_factory(unformatted_cards)
    View.game_intro
    View.print_definition
    user_input = get_user_input
    evaluate_user_input(user_input)
  end

  def get_user_input
    View.get_answer
    @answer=gets.chomp
    # returns "input" for evaluate_user_input
  end

  def evaluate_user_input(input)
    # determine whether user is guessing or giving command
    if is_input_true?
      View.you_rock
    else 
      View.try_again
    end
    # else execute command
  end

  def is_input_true?
    @answer.downcase == get_top_card_answer.downcase
  end  

  def get_top_card_answer
    @game_deck.get_top_card.answer
  end

  def get_top_card_definition
    @game_deck.get_top_card.definition
  end
end

filename = 'flashcard_samples.txt'
our_controller = Controller.new(filename)
our_controller.run

# talk to viewer have viewer prompt
# viewer provides a definition
# get_user_input
# evaluate_user_input
# is_input-true?
