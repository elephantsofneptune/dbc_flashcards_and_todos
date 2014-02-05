module DataParser

  def q_a_pairs

    data = []
    File.foreach('flashcard_samples.txt') { |line| data << line.chomp }
    pairs = (data.map {|i| i if i != " "}.compact!)
    Hash[*pairs.flatten]

  end

end


class Interface

  attr_reader :user_input

  def initialize
    welcome_statement
  end

  def welcome_statement
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end


  def self.correct
    puts "Correct! Here is the next question:"
  end

  def self.wrong_answer
    puts "Nope! Try again:"
  end

end


class Controller

  include DataParser

  attr_reader :user_input

  def initialize
    Interface.new
    @card_ary = []
    make_deck
    @card_deck = Deck.new(@card_ary)
    go_thru_deck
  end

  def make_deck
    q_a_pairs.each_pair do |definition, word|
      @card_ary << FlashCard.new(definition, word)
    end
  end

  def go_thru_deck
    until @card_ary.empty?

      @card_ary.each do |card|
        puts "Definition: #{card.card_definition}"
        @user_input = gets.chomp

        until @user_input == card.card_answer
          Interface.wrong_answer
          @user_input = gets.chomp
        end
        Interface.correct
        delete_from_deck(card)
      end
    end
  end

  def delete_from_deck(card)
    @card_ary.delete(card)
  end

end



class FlashCard

  attr_reader :card_definition, :card_answer

  def initialize(card_definition, card_answer)
    @card_definition = card_definition
    @card_answer = card_answer

  end
end




class Deck
  include DataParser

  attr_accessor :card_ary

  def initialize (card_ary)
    @card_ary = card_ary.shuffle!
  end
end






# ------------




game = Controller.new