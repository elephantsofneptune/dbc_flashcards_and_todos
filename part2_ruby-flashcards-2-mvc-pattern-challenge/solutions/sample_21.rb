# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-02-08T05:09:52+00:00

class Card
  attr_accessor :guesses, :runs
  attr_reader :definition, :term

  def initialize(definition, term)
    @definition = definition
    @term = term
    @guesses = 0
  end
end

class GameController
  attr_accessor :runs, :incorrect, :correct
  attr_reader :file_name, :cards

  def initialize(file_name)
    @file_name = file_name
    @cards = []
    @runs = 0
    @correct = []
    @incorrect = []
    parse_file
  end

  def parse_file
    File.open(self.file_name, "rb").each_line do |file|
      line = file.split(";")
      @cards << Card.new(line[0], line[1])
    end 
  end

  def average_guess(card)
    card.guesses / self.runs
  end

end

class GameView
  attr_reader :controller

  def initialize(controller)
    @controller = controller
    @finish = false
  end

  def run!
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition. Ready? Go!"
    puts ""
    @controller.incorrect = @controller.cards.clone
    game_loop
      puts "Congrats, you've finished in #{@controller.runs} runs!"
      puts "Press any key to play again or e to exit"
      response2 = $stdin.gets.chomp
      if response2 == "e"
        puts "Thanks for playing!"
      else
        @controller.incorrect = @controller.cards
        run!
      end
  end

  def game_loop
    until @controller.incorrect.empty?
      @controller.incorrect.each do |card|
        puts "Definition"
        puts card.definition
        puts ""
        print "Guess:"
        response = $stdin.gets.chomp
        card.guesses += 1
        if response.strip.downcase == card.term.strip.downcase
          puts "Correct!"
          puts ""
          @controller.correct << card
          @controller.incorrect.delete(card)
        else
          puts "Incorrect!"
          card.guesses += 1
        end
      end
      @controller.runs += 1
    end
  end

  def repeat_cards
    @controller.cards.each do |card|
    end
  end

end

file_name = ARGV[0].to_s
gamecontroller = GameController.new(file_name)
gameview = GameView.new(gamecontroller)
gameview.run!

