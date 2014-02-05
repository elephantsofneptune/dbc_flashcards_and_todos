# Main file for 
class Game
  attr_reader :deck, :name
  def initialize(file, name)
    file = File.new(file)
    @deck = Deck.new(:name => name)

    file.parse.each do |args|
      @deck.add_card(Card.new(args))
    end
    @deck.shuffle!
  end

  def play!
    puts "Welcome to the movie game!" # replace 'the' with: #{@deck.name}
    puts "------------------------------------"
    puts "You will be shown a movie quote and"
    puts "must guess the name of the movie."
    puts "(Entering 'quit' will end the game.)"
    puts "Ready? Go!"

    until @deck.cards.empty?
      next_card
      show_definition
      guess = gets.chomp
      p correct?(guess)
    end
  end

  # gets next card from deck
  def next_card
    @card = @deck.get_card
  end

  def correct?(guess)
    guess == @card.term
  end

  # displays the definition to user
  def show_definition
    p @card.definition
  end
end

class Deck
  attr_reader :cards, :discards

  def initialize(opts = {})
    @name     = opts[:name]
    @cards    = []
    @discards = []
  end

  def shuffle!
    @cards.shuffle!
  end

  def add_card(card)
    @cards << card
  end

  def get_card
    next_card = @cards.shift
    @discards << next_card
    next_card
  end
end

class Card
  attr_reader :definition, :term

  def initialize(card_info = {})
    @definition = card_info[:definition]
    @term = card_info[:term]
  end
end

class File
  def initialize(filename)
    @filename = filename
  end
  # Return an Array of Hashes
  # Each Hash as a :definition key and a :term key
  # corresponding to the term and definition for the flash card file
  def parse
    File.readlines(@filename).each_slice(3).map do |definition, term, _|
      {:definition => definition.chomp, :term => term.chomp}
    end
  end
end

game = Game.new('movie_quotes.txt', 'Movie Quotes')
game.play!
