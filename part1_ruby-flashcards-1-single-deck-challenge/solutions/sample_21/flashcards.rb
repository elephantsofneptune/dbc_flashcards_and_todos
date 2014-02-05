module RubyFlashCards
  DATA_FILE = "sample_cards.txt"
  GREEN = "\e[0;32m"
  RED = "\e[0;31m"
  RESET ="\e[0m"

  class Card
    attr_reader :term, :definition

    def initialize(term, definition)
      @term = term
      @definition = definition
    end

    def to_s
      "#{@term}: #{@definition}"
    end
  end

  class Game
    def initialize
      @cards = create_cards_from DATA_FILE
      @cards.shuffle!
    end

    def play
      puts "Welcome to Ruby Flash Cards."
      puts "To play, just enter the correct term for the definition."
      puts "To exit, press return without typing an answer."
      puts "Ready? Go!"
      print_new_line
      prompt_user
    end

    private
    def prompt_user
      @cards.each do |card|
        puts "Definition"
        puts card.definition
        print_new_line
        print "Guess: "
        if user_input.downcase == card.term.downcase
          color_print("Correct!", GREEN)
        else
          color_print("Incorrect!", RED)
        end
        print_new_line
      end

      color_print("GAME OVER", RED)
    end

    def print_new_line
      print "\n"
    end

    def user_input
      input = gets.chomp
    end

    def color_print(string, color)
      puts "#{color}#{string}#{RESET}"
    end

    def create_cards_from(file)
      cards = []
      File.open(DATA_FILE) do |f|
        lines = f.readlines.map! { |line| line.chomp }
        lines.delete("")
        lines.each_slice(2) do |definition, term|
          cards << Card.new(term, definition)
        end
      end
      cards
    end
  end
end

game = RubyFlashCards::Game.new
game.play
