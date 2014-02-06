# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-02-11T03:15:03+00:00

class Model
  attr_reader :flashcards

  def initialize(file)
    @file = sanitize_file(file)
    @flashcards = []
  end
  
  def count_cards
    flashcards.length
  end
  

  def sanitize_file(file)
    file = File.open(file, 'r') {|file| file.readlines.collect{|line| line.chomp}}
    file.reject! { |element| element.empty? || element == ' ' }
    flashcards = Hash.new
    file.each_slice(2) do |card_array|
      flashcards[card_array[1]] = card_array[0]
    end
    flashcards
  end
  
end

class View

  def welcome_message
    puts 'Welcome to Ruby flashcards.'
  end

  def ask_rounds(number_cards)
    puts "How many rounds would you like to play? There are #{number_cards} in the deck." 
  end

  def display_definition(flashcard)
    puts "Definition:"
    puts flashcard.definition
  end

  def ask_for_answer
    puts ""
    puts "Guess :"
  end

  def correct
    puts ""
    puts "Correct!"
    puts ""
  end

  def incorrect
    puts ""
    puts "Incorrect, please try again!"
  end

  def thanks
    puts "Thanks for playing!"
  end

end

class Controller
  attr_reader :model, :file

  def initialize
    @file = get_deck_file
    @model = Model.new(file)
  end

  def prepare_deck
    model.sanitize_file(file)
  end

  def populate_deck
    model.sanitize_file(file).each do |word, definition|
      model.flashcards << Flashcard.new(word: word, definition: definition)
    end
    @flashcards
  end

  def set_rounds(rounds, model)
    enough_flashcards_to_play?(rounds, model)
    rounds
  end

  def pick_card
    model.flashcards.delete(model.flashcards.sample)
  end

  def check_answer(answer, flashcard)
    return true if answer.downcase == flashcard.word.downcase
  end

  private

  def get_deck_file
    ARGV[0]
  end

  def enough_flashcards_to_play?(rounds, deck)
    rounds <= deck.flashcards.length
  end


end


class Flashcard
  attr_accessor :word, :definition

  def initialize(args)
    @word = args[:word]
    @definition = args[:definition]
  end

end


class Game
  attr_reader :model, :view, :controller

  def initialize
    @controller = Controller.new
    @model = controller.model
    @view = View.new
  end

  def play!
    view.welcome_message
    controller.prepare_deck
    controller.populate_deck
    view.ask_rounds(model.count_cards)
    rounds = $stdin.gets.chomp.to_i
    game_rounds = controller.set_rounds(rounds, model)
    game_rounds.times do 
      card = controller.pick_card
      view.display_definition(card)
      view.ask_for_answer
      answer = $stdin.gets.chomp
      until controller.check_answer(answer, card)
        view.incorrect
        view.ask_for_answer
        answer = $stdin.gets.chomp
      end
      view.correct
    end
    view.thanks
  end

end

game = Game.new
game.play!

