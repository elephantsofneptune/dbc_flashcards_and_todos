require_relative 'deck'
require_relative 'card'

class Flashcards
  def initialize
    @deck = Deck.new
  end

  def play
    puts "Welcome to Ruby Flashcards!"
    puts "Press enter to show a card or type quit to exit:\n\n"
        
    input = gets.downcase.chomp

    until input == "quit"
      chances = 0
      card = display_card
      puts card.def

      until chances == 3 || card.match?(input)
        input = gets.downcase.chomp
        
        break if input == "quit"
        if card.match?(input)
          puts "Nice work!\n"
          break
        else
          chances += 1
          puts "Wrong answer. Try again!\n\n"
          puts card.def
        end
      end
        puts "Answer was: #{card.term} \n\n"

    end
      puts "Thanks for playing!"

  end

  def display_card
    @deck.pick_card
  end

end

game = Flashcards.new
game.play
