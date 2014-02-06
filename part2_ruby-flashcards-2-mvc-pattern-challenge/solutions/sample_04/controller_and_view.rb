require './flashcards.rb'

#View
module View
  
  def show(definition)
    puts "Definition: "
    puts definition
  end

  def goodbye
    puts "Too lazy to keep going? OK fine." 
  end

  def greeting
    puts "Let's have some fun with flashcards! Enter the correct term for each definition."
  end

  def response(bool)
    if bool
      puts "Correct!"
    else
      puts "Incorrect! Try again."
    end
  end
end


# Controller
class Game
  
  include View

  attr_reader :deck, :card
  attr_accessor :definition

  def initialize
    greeting
    @deck = Deck.new(ARGV[0])
    @exit = false
  end

  def play
    until @exit
      select_card
      loop do
        show_definition
        get_guess
        response(verify_guess)
        break if @card.correct || @exit
      end
    end
  end
  
  def select_card
    @card = @deck.select_card
  end

  def show_definition
    show(@card.definition)
  end

  def get_guess
    @guess = STDIN.gets.chomp
    exit if @guess == "exit" 
  end

  def exit
    goodbye
    @exit = true
  end

  def verify_guess
    @card.check_guess(@guess)
  end
end


# DRIVER CODE
game = Game.new
game.play