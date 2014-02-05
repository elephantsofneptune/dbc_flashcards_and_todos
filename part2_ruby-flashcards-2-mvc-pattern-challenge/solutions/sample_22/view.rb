class View

  class << self

    def player_guess
      @guess
    end

    def guess=(input)
      @guess = input
    end

    def line_break
      "*" * 50
    end

    def line_break_end
      puts line_break
      puts
    end

    def render(message, arg = nil)
      arg == nil ? send(message) : send(message, arg)
    end

    def welcome(file)
      puts line_break
      puts "Weclome to the flashcard spectacular!  You're using the '#{file}' deck."
      puts "Enter 'q' at any time to quit this program"
      puts line_break_end
    end

    def exit
      puts line_break
      puts "Thanks for playing, byeeeeeeeeeee!"
      puts line_break_end
    end

    def definition(card_definition)
      puts "Definition"
      puts "#{card_definition}"
      puts
    end

    def get_guess
      print "Please enter a guess >  "
      self.guess = STDIN.gets.chomp
      puts
    end

    def correct_card
      puts "Good Job! That's correct!"
      puts line_break_end
    end

    def incorrect_card(card_definition)
      puts "Almost.... try it again!"
      puts line_break_end
      definition(card_definition)
    end

    def try_again
      puts line_break
      puts "You got the following cards wrong too many times.  Try again!"
      puts "Enter 'q' at any time to quit this program."
      puts line_break_end
    end
    
  end
end
