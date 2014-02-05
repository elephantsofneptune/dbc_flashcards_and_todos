class UI

  def initialize
    clear_screen!
    move_to_home!
    puts "Welcome, to..."
    sleep(1)
    clear_screen!
    move_to_home!
    title
    puts "Here's your first definition.  Give us the right term."
    wait_time
  end

  def wait_time
    puts ""
    puts "Press enter to move on."
    STDIN.gets.chomp
  end

  def title
    print_line
    puts "Mac_Austin_Kris_Allen's Amazing Flashcards Game!"
    print_line
  end

  def user_prompt
    puts "Type EXIT to end game.\n\n"
    print "Type your guess here:"
  end

  def display_def(card)
    clear_screen!
    move_to_home!
    title
    puts "#{card.definition}"
  end

  def display_answer(card)
    puts "#{card.term}"
    wait_time
  end

  def retrieve_guess
    user_prompt
    STDIN.gets.chomp
  end

  def display_result
  end

  def wrong_answer(guess, current_card) 
    clear_screen!
    move_to_home!
    title

    puts "You answered #{guess}, which is not right :(."
    puts "Try again..."
    print_line
    puts "Number of attempts: #{current_card.attempts}"
    puts "#{current_card.definition}"
  end

  def correct_answer(guess)
    clear_screen!
    move_to_home!
    title

    puts "You answered #{guess}, which is CORRECT!"
    puts "Congratu-f\'ng-lations :)"
    puts "On to the question."
    wait_time
  end

  def reputs(str = '')
    puts "\e[0K" + str
  end

  # Clear the screen
  def clear_screen!
    print "\e[2J"
  end

  # Moves cursor to the top left of the terminal
  def move_to_home!
    print "\e[H"
  end


  # Flushes the STDOUT buffer.
  # By default STDOUT is only flushed when it encounters a newline (\n) character
  def flush!
    $stdout.flush
  end

  def print_line
    puts "---------------------------------------------------"
  end

  def display_most_attempted(most_attempted)
    most_attempted.each do |card|
      puts "TERM:#{card.term}\nDEFINITION:#{card.definition}\nATTEMPTS:#{card.attempts}\n\n"
    end
    # puts most_attempted.join(" \n")
  end

  def game_over
    puts "You are FINISHED!!"
  end

end