# Logic of the game
# => User gets definition from a card
# => User has to guess the term
# => If term is right
#      Inform the user
#      go to next question
# => If term's not right
#     Inform the user
#     repeat the question
#  Go to next card
#  When you run out of cards
#   Show score
#   End the game
# 


# Classes
# Card => Definition, term
# Game => Deck, intro to game, term_right, term_wrong, next_card, end of game, score
# 

Flashcard = Struct.new(:term, :definition)

class CardGame
  attr_accessor :deck
  def initialize
    @deck = []
    @current_card = 0
  end

  def self.from_file(file)
    defn = term = ''
    game = self.new
    File.open(file).each_with_index do |line, index|
      defn = line.chomp if (index % 3) == 0
      term = line.chomp if (index % 3) == 1
      game.deck << Flashcard.new(term, defn) if (index % 3) == 2
    end
    game
  end

  def intro
    puts "Welcome to guess or die, hope you said farewell to your family"
    puts "Press Enter to enter this world of thrills"
  end

  def guess?
    get_answer == title
  end

  def title
    @deck[@current_card][:term]
  end

  def definition
    @deck[@current_card][:definition]
  end

  def show_card
    puts definition
  end

  def next_card
    @current_card += 1
  end

  def end_game
    puts "Congratulations, come back next week for your million dollars"
  end

  def get_answer
    gets.chomp
  end

  def questions
    until guess?
      show_card
    end
    next_card
  end

  def last_card?
    @current_card == @deck.size
  end

  def start!
    intro
    until last_card?
      questions
    end 
    end_game
  end

end



game = CardGame.from_file "music_flashcards.txt"
game.start!
