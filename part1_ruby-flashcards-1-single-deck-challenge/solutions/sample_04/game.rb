# Main file for 
require 'csv'
require_relative 'deck'
require_relative 'flashcard'


class Game
  def initialize(flashcard_file)
    @flashcard_deck = Deck.new(flashcard_file)
    @correct_answers = 0
    @current_card = @flashcard_deck.current_card
    @deck_size = @flashcard_deck.size
    @num_of_guesses = 0
  end
  

  def run!
    puts "Game Started!"
    @deck_size.times do 
      print "#{@current_card.definition} : " 
      @num_of_guesses = 1
      until @num_of_guesses == 4
        user_answer = gets.chomp.downcase
        if correct?(user_answer)
          guess_is_correct
        else
          guess_is_incorrect
        end
      end
      flip_to_next_card
    end
    
    puts "Congrats! You got #{@correct_answers} correct answers!"
  end

    # def user_answer
    #   gets.chomp.downcase
    # end

  def flip_to_next_card
    @flashcard_deck.next_card
    @current_card = @flashcard_deck.current_card
  end

  def correct?(user_answer)
    user_answer == @current_card.term
  end

  def guess_is_correct
    puts "Correct!"
    @correct_answers += 1 
    @num_of_guesses = 4
  end

  def guess_is_incorrect
    @num_of_guesses += 1
    if @num_of_guesses == 4
      puts "You're out of guesses. Let's move on to the next card" 
    else
      puts "Wrong. #{4 - @num_of_guesses} guesses left!"
    end
    # puts "#{@current_flashcard.definition} : "
  end

  # def print_result
  #   @correct_answers > 0 ? "Congrats! You got #{@correct_answers} correct answers!" : "Dude you got'em all wrong..."
  # end

end



game = Game.new('flashcards.csv')
game.run!



