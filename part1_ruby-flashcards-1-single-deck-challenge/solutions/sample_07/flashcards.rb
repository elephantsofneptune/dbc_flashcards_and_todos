# Main file for 

class Flashcard
  attr_reader :answer, :question

  def initialize(answer, question)
    @answer = answer
    @question = question
  end


  def check_answer?(user_guess, card)
    return true if user_guess == card.answer
    false
  end

end

class FlashcardStack
  attr_reader :deck

  def initialize(deck)
    @deck = deck
  end

  def shuffle!
    self.deck.shuffle
  end

  def get_card(shuffled_deck)
    shuffled_deck.shift
  end

end

class FileParser

  def self.load #magic, don't touch
    all_flashcards = []
    f = File.open("flashcard_sample.txt")
    f_lines = f.read.split("\n")
    f_lines.reject! { |element| element == "" }
    (f_lines.length / 2).times { |x| all_flashcards << Array.new(f_lines.shift(2)) }
    

    all_flashcard_objects = all_flashcards.map do |flashcard|
      Flashcard.new(flashcard[1], flashcard[0])
    end

    return all_flashcard_objects

  end

end


class UserInterface

  attr_reader :new_game

  def initialize
    @new_game = FlashcardStack.new(FileParser.load)
  end


  def play_game
    num = new_game.shuffle!.length
    puts "\n"
    puts "-------------------------------"
    puts "#{num} questions\n"
    puts "-------------------------------"
    puts "\n"

    new_game.shuffle!.each_with_index do |card, num|
      try_counter = 0


      puts "Question #{num+1} \n#{card.question}\n"
      print "Answer: "
      while try_counter <= 2   
       
        user_guess = gets.chomp

        if user_guess == 'exit'
          puts "\nGoodbye"
          return
        end

        if card.check_answer?(user_guess, card) == true
          puts "Correct! \n"
          try_counter = 3
        else
          print "Try Again: "
          try_counter += 1
        end
      end
      if user_guess != card.answer
        puts "Moron! The answer is \"#{card.answer}\"\n\n"
      end
    end

    exit_logic

  end


  def exit_logic
    puts "Do you want to play again? "
    input = gets.chomp

    if input == 'yes' 
      play_game
    else
      return
    end
  end


end



ui = UserInterface.new
ui.play_game