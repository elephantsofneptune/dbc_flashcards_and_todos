# Main file for 
# Authors: Alex Ray, Conor Flanagan, Nick Ibanez, Joshua Teng

module DeckData

  #I already made changes dude
  #Josh says hello!

  def self.deck_generate_txt(file)
    card_data_raw = File.open(file).readlines
    deck = []
    current_card = {}

    card_data_raw.each_with_index do |line, index|

      if on_definition?(index)
        current_card[:definition] = line.chomp
      elsif on_answer?(index)
        current_card[:answer] = line.chomp
        deck << Card.new(current_card)
        current_card = {}
      end

    end
    deck
  end
        
  def self.on_definition?(index)
    index % 3 == 0
  end

  def self.on_answer?(index)
    index % 3 == 1
  end

end


class Deck
  attr_reader :card_array

  def initialize(file)
    @card_array = []
    @file = file
    load!
    shuffle_deck!
  end

  def shuffle_deck!
    @card_array.shuffle!
  end

  def load!
    @card_array = DeckData::deck_generate_txt(@file)
  end
end

class Card
  attr_reader :definition, :answer

  def initialize(args)
    @definition = args[:definition]
    @answer = args[:answer]
  end

end

module Ui
  def splash_screen
    puts "Welcome to Flash Cards Game!"
    puts "Type 'show' to reveal solution"
    puts "Type 'exit!' to exit the game"
    puts " " 
  end

  def self.user_output(text)
    puts text
    puts " "
  end

  def self.user_input
    print "Guess: "
    gets.chomp
  end

end

class Game
  include Ui
  
  def initialize(deck)
    @card_array = deck.card_array
    play_deck
  end

  def play_deck
    splash_screen
    @card_array.each do |card|
      break if play_card(card) == "break" 
    end
    Ui::user_output("Thanks for playing!")

  end

  def play_card(card)
    Ui::user_output("Definition: #{card.definition}")
    answer = Ui::user_input
    if evaluate_answer(card, answer)
      Ui::user_output("Correct!")
    elsif answer == "show"
      Ui::user_output("The answer is: #{card.answer}!")
    elsif answer == "exit!"
      return "break"
    else
      Ui::user_output("Erroneous!!")
      play_card(card)
    end
  end

  def evaluate_answer(card, answer)
    card.answer == answer
  end

end

########## Driver code #########

# Setting up new deck with cards.txt file
deck1 = Deck.new('cards.txt')
# Initializing Game!
Game.new(deck1)