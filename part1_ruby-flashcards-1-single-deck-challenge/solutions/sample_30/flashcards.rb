# Main file for 

# GIVEN: textfile with questions (front) and one-word answer (back)
# INPUT: user input (string)
# OUTPUT: cycles thru each card until user_input matches one-word answer (back)

# 1. input file.txt =====> done
# 2. parsing -> to card_object with front and back. =====> done
#   - front: question =====> done
#   - back: one-word answer =====> done
# 3. create cardset to interact with =====> done
# 4. start card_set game
#   a) display question (Card object attribute question)
#   b) take user_input
#   c) evaluate against card answer (Card object attribute answer)
#   d) conditional loop
# 5. END game?




class ParserClass
  def self.file_splitter(filepath)
    File.open(filepath).readlines.each { |line| line.chomp! }.delete_if { |element| element == "" }.each_slice(2).to_a
  end
  
  def self.make_card(array)
    Flashcard.new(array)
  end

  def self.new_cardset(filepath)
    holder = CardSet.new
    file_splitter(filepath).each do |q_and_a_pair|
      holder.deck << make_card(q_and_a_pair)
    end
    holder
  end
end


class Flashcard
  attr_reader :question, :answer
  def initialize(q_and_a_array)
    @question = q_and_a_array[0]
    @answer = q_and_a_array[1]
  end
end


class CardSet
  attr_accessor :deck
  def initialize
    @deck = []
  end
end


class ViewerClass
  def self.print_flashcard

  end
end


class Game
  attr_reader :game_set

  def initialize(filepath)
    @game_set = ParserClass.new_cardset(filepath)
  end

  def play(user_input = '')
    puts "Welcome to Flashcardsters!!! Find the right answer (or: skip)."
    puts "------------------------------------------------------------------------------"
    @game_set.deck.each do |card| 
      until user_input == card.answer
        puts card.question
        user_input = gets.chomp
        break if user_input.downcase == 'skip'
      end
      # puts "Correct! How about THESE apples:"
      # # puts
    end
  end

  def show_next_flashcard
  end
end

################ DRIVER CODE ################ 

# new_game = ParserClass.new('flashcard_samples.txt')
# file_new = File.open('flashcard_samples.txt').readlines
# test = file_new.each{|line| line.chomp! }
# p test.delete_if {|x| x == ""}



# new_game.make_card([1,2])

# test = ParserClass.new
# p test.file_splitter
# p test.make_card([1,2])
game = Game.new('flashcard_samples.txt')
game.play

