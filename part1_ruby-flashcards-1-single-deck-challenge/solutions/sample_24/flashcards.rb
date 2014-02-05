# Flashcards, Ryan, Laura, Paul, and Carter
 
 
class Card
  attr_reader :definition, :term
  def initialize(definition, term)
    @definition = definition
    @term = term
  end
end
 
class Deck
  def initialize(filename = "")
    @filename = filename
    @text_array = []
    @card_deck = []
  end
 
  def parse
    f = File.open(@filename, 'r').each_line do |line|
      @text_array << line.chomp
    end
    @text_array #Deck.new returned
  end
 
  def make_cards
    @text_array.each_slice(3).to_a.each do |i|
      new_card = Card.new(i[0], i[1])
      @card_deck << new_card
    end
    @card_deck
  end
 
 
 
end
 
 
class GameController
  def initialize(deck)
    @deck = deck
    @counter = 0
  end
 
  def next_card
    card = @deck[@counter]
    @counter += 1
    card
  end
 
  def play!
    @deck.shuffle!
    puts "Welcome to the best game EVER!"
    puts ""
    puts "Guess the term to the following definition (enter 'exit' to quit)"
    puts ""
    guess = ""
    new_card = next_card
    until guess == "exit" || @counter == @deck.length
      puts "Definition: #{new_card.definition}"
      puts ""
      print "Guess: "
      guess = gets.chomp
      if guess == new_card.term
        puts "CORRECT!\n"
        new_card = next_card
      elsif guess != new_card.term and guess != "exit"
        puts "INCORRECT! Try again:\n\n"
 
      else
        puts "GAME OVER"
        puts "#{@counter-1} questions answered correctly, good job!"
      end
    end
  end
end
 
#DRIVER CODE
deck = Deck.new('flashcard_samples.txt')
deck.parse
game1 = GameController.new(deck.make_cards)
game1.play!
 
 
 
def assert(expression)
  raise "Test Failed" unless expression
end