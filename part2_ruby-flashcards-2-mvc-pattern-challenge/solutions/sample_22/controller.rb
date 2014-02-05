require_relative 'view'
require_relative 'model'

class Controller 
  attr_reader :text, :our_deck

  class << self

    def run
      open_and_parse_file
      @our_deck = Deck.new(create_flash_cards)
      Game.play(@our_deck)
    end

    def open_and_parse_file
      ARGV[0] = "flashcards.txt" unless ARGV.any?
      @text = File.open(ARGV[0], 'r').readlines #opens file and reads it
      @text = @text.join("").split("\n \n").map { |element| element.split("\n") }
    end

    def create_flash_cards
      flash_cards = []
      @text.each do |definition, term|
        flash_cards << {definition: definition, term: term}
      end
      flash_cards
    end

  end
end

class Game

  class << self

    def play(our_deck)
      @our_deck = our_deck
      View.render(:welcome, ARGV[0])
      @our_deck.cards.each { |card| ask_for_guess(card) }

      repeat_wrong_cards
      View.render(:exit)
    end

    def repeat_wrong_cards
      wrong_cards_remaining = (@our_deck.wrong_cards.length > 0 ? true : false)
      
      while wrong_cards_remaining
        View.render(:try_again)
        @our_deck.remove_wrong_cards
        @our_deck.reset_guesses

        @our_deck.cards.each { |card| ask_for_guess(card) }
        wrong_cards_remaining = false if @our_deck.wrong_cards.length == 0
      end
    end

    def ask_for_guess(card)
      correct_guess = false
      View.render(:definition, card.definition)
      until correct_guess
        correct_guess = check_guess(card, guess_from_player)
      end
    end

    def guess_from_player
      View.render(:get_guess)
      View.render(:player_guess)
    end

    def check_guess(card, guess)
      case guess  
      when card.term    # card.match_definition(guess)
        View.render(:correct_card)
        return true
      when "q"
        View.render(:exit)
        exit
      else
        View.render(:incorrect_card, card.definition)
        card.wrong_guess
        @our_deck.build_wrong_deck(card)
      end
      false
    end

  end
end

Controller.run
