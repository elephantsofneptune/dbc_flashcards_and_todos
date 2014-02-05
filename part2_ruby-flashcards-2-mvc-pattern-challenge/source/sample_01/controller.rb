# Main file for Controller and View
require_relative 'flashcard.rb'

class Controller

  def initialize(filename)
    @new_deck = Deck.new(filename)
    @cards = @new_deck.cards.shuffle
  end

  def start_game
    View.welcome
    until @cards[0] == nil
      card = @cards[0]
      View.prompt(card.definition)
      guess = gets.chomp
      if guess == card.word
        View.correct
        card = @cards.shift
      elsif guess == 'exit'
        View.exit
        break
      elsif guess == 'answer'
        View.answer(card.word)
      else
        View.incorrect
      # if guess != card.word
      #   View.incorrect
      end
    end
  end
end

class View

  def self.welcome
    puts "Hey man, let's learn some Ruby."
    puts
  end

  def self.prompt(definition)
    puts "\nPlease return the term for this definition: \n#{definition}\n"
  end

  def self.correct
    puts "\nCongrats! \n**********************\n"
  end

  def self.incorrect
    puts "\nNot quite, but so close. Try again!\n"
  end

  def self.answer(answer)
    puts "\nThe first letter is #{answer[0..2]}\n"
  end

  def self.exit
    puts "\nThanks for playing!"
  end



end