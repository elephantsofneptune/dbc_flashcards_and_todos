class View
  CONGRATS = ["a baller", "a shot caller", "a gangsta", "a real great person", "amazing", "radical", "magnificent"]


  def welcome_screen
    puts "Welcome to Ruby Flash Card - Deluxe Edition"
  end

  def instructions
    puts "INSTRUCTIONS! Type the word or phrase that matches the given definition."
    puts "Type 'exit' to quit the program."
    puts "Type 'shuffle' to move on the next card."
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts ""
  end

  def show_definition(card)
    card.definition
  end

  def show_answer(card)
    puts "The answer was: #{card.answer}"
  end

  def correct_answer
    puts "Correct! You're #{CONGRATS.sample}!"
  end

  def guess_again
    puts "Nice try, but no cigar. Guess again!"
  end

  # Clear the screen
  def clear_screen!
    print "\e[2J"
  end

  # Moves cursor to the top left of the terminal
  def move_to_home!
    print "\e[H"
  end

end
