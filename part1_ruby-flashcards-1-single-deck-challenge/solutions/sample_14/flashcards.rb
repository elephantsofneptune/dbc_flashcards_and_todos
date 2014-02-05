class Flashcard 
  attr_accessor :term, :definition

  def initialize(args)
    @term = args[:term]
    @definition = args[:definition]
  end  
end


#tested this and it works - creating a new deck reteurns current_card if given a hash
class Deck
  attr_accessor :deck
  #to create deck, calls new factory, passes it input file
  def initialize
    @deck = Factory.new(@deck_data)
    @current_card = []
  end

  def shuffle!
    @deck << Hash[@deck.to_a.shuffle!]
  end

  def pick_card
    @current_card = @deck.shift
  end
  @current_card

end


module Factory

  require 'CSV'
  attr_reader :file

  def initialize(file)
    @file = file 
    @deck_data = []
  end 

  def deck 
    return @deck unless @deck.empty?
    file_parse(@file)
    @deck_data
  end 

  def file_parse
    CSV.foreach(@file, :headers => true) do |row|
      @deck_data << Flashcard.new(row[0], row[1])
    end 
   
  @deck_data
  end 
end


class Game

  include Factory
  
  attr_reader :file, :deck
  #initializes new game with input file, passes to Deck class to create deck
  def initialize(file)
    @file = file
    @deck = Deck.new(file)
  end
  #starts game loop
  puts "Welcome to Flashcards Game! To play, enter the correct term for each prompted definition. To play the game, hit ENTER. To quit the game at any time, type QUIT."
  until gets.chomp.downcase == 'quit'

    #displays hash value of Flashcard.new and prompts for user answer
    puts "Definition:"
    p @deck[1]
    current_guess = gets.chomp.downcase
    until current_guess == @deck[0].to_s.downcase || current_guess == 'quit'
      puts "Guess again!" #how to add quit here 
      current_guess = gets.chomp.downcase
    end
    if current_guess == 'quit'
      puts "Try again soon!"
      break
    else
      puts "Correct answer! Nice job! Hit ENTER to play again, type QUIT to quit game."
    end
  end
  
end

# DRIVER CODE
#initializes new game with csv file, passes file to Game class
game = Game.new('./testdata.csv')

# how to deal with hints?
# once a card has been guessed correctly, dont re-use

