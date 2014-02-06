# Main file for 
class Deck

  def initialize(file_name)
    @cards = FileHandler.parse_to_card_array(file_name).map do |hash|
      Card.new(hash)
    end
  end

  # def grab_card_stack


  # end
  def shuffle
    @cards.shuffle!
  end

  def draw
    @cards.shift
  end

  def to_s
    deck_string = ""
    @cards.each { |card| deck_string << "#{card}\n\n"}
    deck_string
  end

  def empty?
    @cards.empty?
  end
   
  # @deck = Deck.new( filename )
  # @deck.cards

end

class Card
  attr_reader :word, :definition

  def initialize(word_definition_hash)
    @word = word_definition_hash[:word]
    @definition = word_definition_hash[:definition]
  end

  def to_s
    "Word: #{@word}\n#{@definition}"
  end

end

class FileHandler 
  def self.parse_to_card_array(file)
    # Takes filename as input
    # Returns Array of Hash objects
    # { :definition => word definition ,
    #   :term => word name }
    card_array = []
    file_array = File.readlines(file)
    file_array.map! { |line| line.chomp }
    file_array.each_slice(3) do |single_card|
      card_array << Hash[:definition, single_card[0], :word, single_card[1]] 
    end
   card_array
  end
end

# puts FileHandler.parse_to_card_array('flashcard_samples.txt')

class Viewer
  def self.display_to_console(output)
    puts output
  end
end


class GameController
  ASK_QUESTION = "Here is the definition. What is the word?!? If you give up, type 'I LOVE TURTLES!'"
  TRY_AGAIN = "WRONG!!!! Try harder."
  RIGHT_ANSWER = "Awesome job. You got the right answer."

  def initialize(name_of_file_txt)
    @name_of_file_txt = name_of_file_txt
  end

  def run(name_of_file_txt)
    @my_deck = Deck.new(name_of_file_txt)
    @my_deck.shuffle
    # Viewer.display_to_console(@my_deck)
    select_card
  
    until @my_deck.empty?
      puts
      @current_card = select_card
      ask_question
      guess = get_input
      until answer_is_correct?(guess)
        Viewer.display_to_console(TRY_AGAIN)
        guess = get_input
      end
      Viewer.display_to_console(RIGHT_ANSWER)

    end

  # my_deck Card.new(word_definition_hash)
  end

  def select_card
    @my_deck.draw
  end

  def ask_question 
    Viewer.display_to_console(ASK_QUESTION)
    Viewer.display_to_console(@current_card.definition)
  end

  def answer_is_correct?(input)
    input == @current_card.word || input == 'I LOVE TURTLES!'
  end

  def get_input
    gets.chomp
  end
end

game = GameController.new('flashcard_samples.txt')
game.run('flashcard_samples.txt')