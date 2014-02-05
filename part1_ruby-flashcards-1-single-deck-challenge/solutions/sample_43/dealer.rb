require './deckofcards.rb'

class Dealer
  attr_reader :guess, :deck, :drawn_card

  def initialize(deck)
    @deck = deck
  end

  def prompt_guess
    puts "Guess:"
    @guess = gets.chomp    
  end

  def print_correct
    puts "Correct!"
    puts
  end

  def print_incorrect
    puts "Incorrect! Try again."
    puts
  end

  def draw_card
    @drawn_card = deck.card_db.shuffle!.pop
  end

  def display_definition(drawn_card)
    puts drawn_card.definition
  end

  def welcome
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition. Ready? Go!"
    puts
  end

  def exit
    puts "That's all the cards. Thanks for playing!"
  end

  def guess_loop_on_one_card
    until deck.correct?(guess, drawn_card.answer)
      print_incorrect
      prompt_guess
    end
  end

  def guess_loop_on_deck
    while deck.card_db != []
      draw_card
      display_definition(drawn_card)
      prompt_guess
      guess_loop_on_one_card
      print_correct
    end
  end

  def play!
    welcome
    guess_loop_on_deck
    exit
  end
end

my_deck = Deck.new('flashcard_samples.txt')
Dealer.new(my_deck).play!

