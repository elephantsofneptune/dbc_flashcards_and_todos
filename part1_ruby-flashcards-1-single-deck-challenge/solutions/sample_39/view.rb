class View
  def self.game_intro
    puts "Welcome to the game"
    # puts "rules ie 'shuffle'"
  end

  def self.print_definition(string)
    puts "Definition"
    puts string
    puts
  end

  def self.get_answer
    print "Guess:"
  end

  def self.try_again
    puts "Sorry, try again."
    puts
  end

  def self.you_rock
    puts "Correct! You rock!"
    puts
  end

  def self.exiting
    puts "Thanks for playing! Goodbye!"
    puts
    puts
  end
end