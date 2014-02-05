require_relative "deck.rb"

module View
# I moved some of the printing code into a module just to try out how to do it. 
# Im this case I do not see the value yet.   

  def greeting
    puts ["", "Welcome to Ruby Flash Cards!", "To play, just enter the correct term for each definition,"\
          " or \"H\" for help"]
  end

  def help_text
    puts ["", "***************************", "List of commands:", " A - gives answer",
          " H - brings up this menu", " Q - exits the program", "***************************"]
    evaluate_guess(gets.chomp!) 
  end

  def give_answer
    puts "The answer to the last definition is \"#{@card.answer}\""
  end
end

# ******************************************************************************
class GameController

  include View

  def initialize(deck)
    @deck = deck
    @menu_list = {"A" => "give_answer", "Q" => "end_game", "H" => "help_text" }
    # this hash is used to get rid of a large IF statment that took the various inputs
    # and tried to decide if the answer was a false answer or the user
    # was just trying to type in a help command.  I used .send to use methods in the
    # value positions of the hash.  

    greeting
    serve_card
  end

  def serve_card
    while @deck.cards_left?
      @card = @deck.get_card
      puts ["", "Definition:", @card.description]
      evaluate_guess(gets.chomp!) 
    end
    puts "You've completed the deck. Nice job!!!"
    end_game
  end

  def evaluate_guess(guess)
    if @card.guess_correct?(guess)
      puts ["", "Correct!", "*********************"]
      @card.mark!
    else
      guess_not_correct(guess)
    end
  end

  # def guess_correct
  #   puts ["", "Correct!", "*********************"]
  #   @card.mark!
  # end

  def guess_not_correct(guess)
    if @menu_list.has_key?(guess.upcase)
      self.send(@menu_list[guess.upcase])
    else
      @menu_list.has_key?(guess)
      puts "Incorrect!  Try again."
      evaluate_guess(gets.chomp!) 
    end
  end

  def end_game
    puts "...Game Over..."
    exit
  end
end

# the original code for game is below.  It was quite large and is now still readable
# short, and to the point.  

game = GameController.new(Deck.new('flashcard_samples.txt'))


# require_relative "deck.rb"

# class Game

#   def initialize(deck)
#     @deck = deck
#   end

#   def end_game
#     exit
#   end

#   def start
#     greeting
#     while @deck.cards_left?
#       play_round
#     end
#     end_game
#   end

#   def play_round
#     @card = @deck.get_card
#     show(@card)
#     next_card_flag = false
#     until next_card_flag
#       user_input = get_user_response
#       next_card_flag = respond_to(user_input)
#     end
#   end

#   def respond_to(user_input)
#     if user_input == "[next]"
#       give_answer
#       return true
#     elsif user_input == "[quit]"
#       end_game
#     elsif user_input == "[help]"
#       help_text
#       return false
#     elsif @card.guess_correct?(user_input)  
#       announce_correct
#       @card.mark!
#       return true
#     else
#       announce_incorrect
#       return false
#     end
#   end

#   def give_answer
#     puts "The answer was \"#{@card.answer}\", you damn dummyhead!"
#   end
  
#   def announce_correct
#     puts "Correct!"
#   end

#   def announce_incorrect
#     puts "Incorrect!  Try again."
#   end

#   def get_user_response
#     gets.chomp!
#   end

#   def show(card)
#     puts "Definition:"
#     puts card.description
#   end

#   def help_text
#     puts "List of commands:"
#     puts " [next] selects a new card"
#     puts " [help] brings up this menu"
#     puts " [quit] exits the program"
#   end

#   def greeting
#     puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
#   end

# end



# game = Game.new(Deck.new('flashcard_samples.txt'))
# game.start
