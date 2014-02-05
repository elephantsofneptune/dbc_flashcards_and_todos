class Card
  attr_reader :term, :definition
  def initialize(definition, term)
    @term = term
    @definition = definition
  end

  def answer(guess)
    guess == @term
  end

  def to_s
    "\nTerm: #{term}\nDefinition: #{definition}\n"
  end
end

class Deck

  attr_reader :cards, :file

  def initialize(file)
    @file = file
    @cards = []
  end

  def create_cards
    File.foreach(@file).each_slice(3) do |lines|
      @cards << Card.new(lines.shift.gsub("\n",""),lines.shift.gsub("\n",""))
    end
  end

  def shuffle
    @cards.shuffle
  end

  def to_s
    output = ""
    @cards.each do |card|
      output += card.to_s
    end
    return output
  end

end

class FlashCardGame

  def initialize(deck)
    @deck = deck
  end

  def play
    puts "\nWelcome to Carolyn's Flash Cards!\n\n"
    puts "Just enter the correct term for each definition.  Ready? Go!\n\n"

    @deck.cards.each do |card|
      puts "Definition: #{card.definition}\n"
      3.times do  |num|  
        puts "Enter your guess: "
        guess = gets.chomp!
        if card.answer(guess)
          puts "correct\n\n"
          break
        elsif num < 2
            puts "\nTry again! \n"
        else 
            puts "\nSorry.  Study harder.  Moving onto the next card\n"
        end
      end
    end
  end
end

my_deck = Deck.new("flashcard_samples.txt")
my_deck.create_cards
my_deck.shuffle
new_game = FlashCardGame.new(my_deck)
new_game.play
