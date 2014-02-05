# Main file for 

class Controller

  def self.run
    deck = Deck.new
    deck.shuffle
    while deck.empty? == false
      UI.clear_screen
      card = deck.draw
      UI.display_definition(card)
      answer = UI.prompt_user
      until answer.downcase == card.answer.downcase
        UI.is_wrong
        answer = UI.prompt_user
      end
      UI.is_correct
      sleep 1
    end
  end

end

class Deck

  attr_reader :contents

  def initialize
    @contents = get_contents
  end

  def get_contents
    contents = []
    output = File.open("flashcard_samples.txt").readlines
    output.select! {|line| line != "\n" }
    output.each_slice(2) do |flashcard|
      contents << Flashcard.new(flashcard[0], flashcard[1])
    end
    contents 
  end

  def shuffle
    @contents = @contents.shuffle
  end

  def draw
    @contents.shift
  end

  def empty?
    @contents.empty?
  end

end 

class Flashcard
  attr_reader :definition, :answer
  def initialize(definition, answer)
    @definition = definition
    @answer = answer
  end
end

class UI

  def self.welcome
    puts "Play with me . . .cowboy"
  end

  def self.display_definition(flashcard)
    puts "#{flashcard.definition}"
  end

  def self.is_correct
    puts "I guess that's right"
  end

  def self.is_wrong
    puts "-----------------------------------"
    puts "Sherif says \"Your answer is shit\""
    puts "-----------------------------------"
  end

  def self.prompt_user
    print "Guess: "
    gets
  end

  def self.clear_screen
    system("clear")
  end

end

Controller.run



# Main file for 