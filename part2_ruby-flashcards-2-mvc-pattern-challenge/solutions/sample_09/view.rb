module View

  def self.welcome
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition."  
    puts "Ready?  Go!"
  end

  def self.question_guess_prompt(flashcard_question)
    puts "\nDefinition:"
    puts flashcard_question 
    print "\nGuess: " 
    STDIN.gets.chomp
  end

  def self.incorrect_guess_prompt
    puts "Oops! Incorrect answer. Please guess again."
    print "Guess: "
    STDIN.gets.chomp
  end

  def self.skip_prompt(flashcard_answer)
    puts "Okay. The correct answer was #{flashcard_answer}."
    puts "Play again or quit?"
    puts "Type 'quit' if you'd like to end the game."
    puts "Type 'continue' if you'd like to continue playing."
    STDIN.gets.chomp
  end

  def self.correct_answer
    puts "Correct answer!  Next question:"
  end

  def self.review_prompt
    puts "Great Job!  You finished the deck."
    puts "Would you like to play again with the cards you got wrong?"
    puts "Type 'yes' or 'no' :"
  end

  def self.end
    puts "\nThanks for playing!"
  end
end
