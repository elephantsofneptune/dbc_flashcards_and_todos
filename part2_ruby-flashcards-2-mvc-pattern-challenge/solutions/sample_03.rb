#Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-02-07T20:15:26+00:00
require 'csv'

# Expects csv file with headers as: id,question,answer
class CardParser
  attr_reader :cards

  def initialize(file)  
    @cards       = []
    parse_cards(file)
  end

  def add_card(card)
    @cards << card
  end

  private
  def parse_cards(file)
    CSV.foreach(file, :headers => true) do |card_data|
      data = Hash[card_data.to_a.map {|k, v| [k.to_sym, v]}]
      @cards << Card.new(data)
    end
  end
end

class Card
  def initialize(data)
    @data = data
  end

  def question
    @data[:question]
  end

  def answer
    @data[:answer]
  end

  def correct_answer?(answer)
    self.answer.downcase == answer.downcase
  end
end

class Deck
  attr_reader :cards

  def initialize(cards = [])
    @cards        = cards
  end

  def add_card(card)
    @cards << card
  end

  def get_card
    self.empty? ? nil : @cards.delete(@cards.sample)
  end

  def remove_card(card)
    @cards.delete(card)
  end

  def empty?
    @cards.empty?
  end
end

class FlashCardController
  LEAVE_RESPONSE     = 'quit'
  INCORRECT_PER_CARD = 3

  attr_reader :deck

  def initialize(deck)
    @view                = View.new
    @deck                = deck
    @current_card        = get_next_card
    @played_cards        = Deck.new
    @last_response       = nil
    @incorrect_responses = 0
  end

  def play!
    @view.welcome_message

    until game_finished?(@last_response)
      @view.render(read_current_card)
      @last_response = @view.get_response
      
      if correct_answer?(@last_response)
        @view.correct_response
        file_card
        reset_responses
        @current_card = get_next_card
      elsif @last_response != LEAVE_RESPONSE
        @view.incorrect_response
        increment_responses
        current_or_next_card
      end

    end

    exit
  end

  private
  def read_current_card
    @current_card.question
  end

  def file_card
    @played_cards.add_card(@current_card)
    @deck.remove_card(@current_card)
  end

  def get_next_card
    @deck.get_card
  end

  def current_or_next_card
    if @incorrect_responses == INCORRECT_PER_CARD
      @current_card = get_next_card 
      reset_responses
    end
  end

  def correct_answer?(answer)
    @current_card.correct_answer?(answer)
  end

  def reset_responses
    @incorrect_responses = 0
  end

  def increment_responses
    @incorrect_responses += 1
  end

  def game_finished?(response)
    response == LEAVE_RESPONSE || @deck.empty?
  end

  def exit
    @deck.empty? ? @view.exit_message : @view.quit_message
  end
end

class View
  INCORRECT_RESPONSES = ["Nope",
                         "Definitely not",
                         "Come on.  That's all you got?",
                         "You can't be serious"]

  CORRECT_RESPONSES   = ["Boom goes the dynamite",
                         "Bingo was his name-o",
                         "Yahtzee!",
                         "Yes!"]

  def initialize
    @last_response = nil
  end

  def get_response
    STDIN.gets.chomp.strip.downcase
  end

  def render(communication)
    puts communication
  end

  def welcome_message
   puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end

  def incorrect_response
    puts INCORRECT_RESPONSES.sample
  end

  def correct_response
    puts CORRECT_RESPONSES.sample
  end

  def quit_message
    puts "Thanks for playing."
  end

  def exit_message
    puts "We're all out of cards.  Thanks for playing."
  end
end

file = ARGV.first
parser = CardParser.new(file)
deck   = Deck.new(parser.cards)
game   = FlashCardController.new(deck)

game.play!
