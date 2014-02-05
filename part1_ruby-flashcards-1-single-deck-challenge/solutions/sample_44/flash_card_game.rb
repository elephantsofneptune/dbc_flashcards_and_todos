require_relative 'deck_loader.rb'
require_relative 'deck.rb'
require_relative 'flashcard.rb'
require_relative 'view.rb'

class FlashCardGame
  attr_reader :deck

  def initialize(file_name)
    @deck = DeckLoader.load_deck(file_name)
    puts "LOADED DECK"
    View.welcome
    run_game
  end

  def run_game
    reply = ""
    @deck.each_card do |flashcard| 
      View.definition(flashcard)
      View.guess
      check_guess(gets.chomp, flashcard.word)
    end
  end

  def check_guess(guess, word)
    if guess == word
      View.correct
    elsif guess == "Q"
      exit_game
    else
      
      View.guess_again
      check_guess(gets.chomp, word)
    end
  end

  def exit_game
    View.goodbye
    exit
  end

  
end

FlashCardGame.new('flashcard_samples.txt')
