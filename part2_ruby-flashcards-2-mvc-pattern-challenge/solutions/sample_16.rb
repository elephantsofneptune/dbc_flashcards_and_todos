require 'csv'
 
class FlashCard
  CARD_ATTRIBUTES = [:id, :term, :def]
 
  attr_accessor :id, :term, :def
 
  def initialize(attributes = {})
    @id   = attributes[:id]
    @term = attributes[:term]
    @def  = attributes[:def]
  end
 
  def match?(guessed_term)
    @term == guessed_term
  end
end
 
class Deck
  DECK_ATTRIBUTES = [:id, :cards, :topic, :file_from, :file_to]
  attr_reader :id, :topic, :file_from, :file_to
 
  def initialize(attributes = {})
    @id        = attributes[:id]        || nil
    @topic     = attributes[:topic]     || 'Ruby Terms'
    @file_from = attributes[:file_from] || UserInterface::FILE
    @file_to   = attributes[:file_to]   || UserInterface::FILE
    @cards     = []
  end
 
  def cards
    return @cards if @cards
    Parser.file_read(@file_from, @cards)
    puts "Cards array now contains #{@cards.inspect}"
  end
 
  def save_file
    @parser.save(@file_to)
  end  
 
  def get_card
    @cards.pop 
  end
 
  def shuffle
    @cards.shuffle!
  end
end
 
 
class Parser
 
  def self.file_read(file, deck)
    file_to_lines = File.readlines(file, "\n\n").map {|element| element.split("\n")}
    file_to_lines.each do |pair|
      deck << FlashCard.new({:def => pair[0], :term => pair[1]})
    end
  end
 
  def self.file_save(file)
    CSV.open(file, "w+") do |row|
      row << FlashCard::CARD_ATTRIBUTES
    end
  end
end
 
class UserInterface
  GUESSES_ALLOWED = 3
  FILE = 'flashcard_samples.txt'
  @@failure_log = 0
  attr_reader :input, :current_card, :attempts, :deck
 
  def initialize
    load_deck
    @deck          = Deck.new(:file_from => @path, :file_to => @path)
    @deck.cards
    @input         = nil
    @current_card  = @deck.get_card
    @attempts      = 0
  end

  def load_deck
    puts "Please enter the file containing your deck."
    @path = gets.chomp
  end
 
  def welcome
    puts "\n\nWELCOME TO RUBY FLASHCARDS, SON!"
    puts "\nYou are using the deck from #{@path}"
    puts "\nTo play, enter the correct term for each definition."
  end
 
  def display_definition
    puts "\nDefinition:\n#{current_card.def}"
  end

  def display_answer
    puts "Come on, SON! The correct answer is: #{current_card.term}"
    @@failure_log += 1
  end

  def display_outcome
    display_answer if attempts == GUESSES_ALLOWED
    puts correct? ? "\nGreat job!" : "\nWoomp woomp wooooooomp. Try again." unless attempts == GUESSES_ALLOWED
  end

  def new_card
    @current_card = @deck.get_card
  end
 
  def get_guess
    @input = gets.chomp!
  end
 
  def correct?
    current_card.match?(@input)
  end
 
  def record_attempts
    @attempts += 1 unless correct?
  end
 
  def reset_attempts
    @attempts = 0
  end
 
  def exceeded_attempts?
    @attempts == GUESSES_ALLOWED
  end
 
  def no_attempts?
    @attempts == 0
  end

  def fails
    puts "You have dishonored your family by failing #{@@failure_log} times, SON!"
  end
 
  def run
    welcome    
    loop do
      new_card if no_attempts?
      display_definition
      get_guess
      record_attempts
      display_outcome
      reset_attempts if correct? || exceeded_attempts?
      fails
    end
  end
end
 
############## DRIVER CODE ################
flash_card_exercise = UserInterface.new
flash_card_exercise.run