# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-02-07T21:45:17+00:00

# It has a couple of bugs, but the 

require 'csv'

class Model

  attr_reader :flashcards

  def initialize(file)
    @flashcards = []
    CSV.foreach(file, :headers => false) do |row|
      @flashcards << Flashcard.new(row.to_a)
    end
    @flashcards
  end

end

class Flashcard
  
  attr_reader :question, :answer

  def initialize(args)
    @question = args[0]
    @answer = args[1]
  end

end


class Controller

  def initialize(file)
    if file =~ /csv\z/
      @deck = Model.new(file) ## Bugbug
      @deck = @deck.flashcards[1..7]
      @deck.shuffle!
      View.new.start_game
      prompt_user
    else
      View.new.incorrect_file
    end
  end
  
  def prompt_user
    @deck.each do |card|
      View.new.print_question(card)
      guess = View.new.guess
      logic(guess, card)### continue here
    end
  end

  def logic (guess, card)
    attempts = 1

    while guess != card.answer
      View.new.incorrect_answer(attempts)   
      attempts += 1
      guess = STDIN.gets.chomp
      return if attempts > 4
    end
    View.new.correct_answer
  end 

end

class View

  def start_game
    puts "Welcome to Ruby Flash Cards. Ready?  Go!"
    puts "To play, just enter the correct term for each definition."
  end

  def incorrect_file
    puts "Please enter a csv file"
    file = gets.chomp
    Controller.new(file)
  end

  def incorrect_answer(attempts)
    puts "You have had #{attempts} attempt" if attempts == 1
    puts "You have had #{attempts} attempts" if attempts > 1
    if attempts > 4 
      "You have tried too many times, Bye"
      return
    else
      puts "Incorrect. Try again"
      puts "Guess: "
    end
  end

  def print_question(card)
    puts card.question
  end

  def guess
    puts "Guess: "
    guess = STDIN.gets.chomp 
  end

  def correct_answer
    puts "Correct"
    Controller.new(ARGV[0])
  end
end



# Driver code

# game = Model.new
# puts game.flashcards.class
# game.render

game = Controller.new(ARGV[0])
game.play