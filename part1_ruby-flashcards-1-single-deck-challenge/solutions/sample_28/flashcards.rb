require 'csv'

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
  LEAVE_RESPONSE = 'quit'

  attr_reader :deck

  def initialize(deck)
    @view            = View.new
    @deck            = deck
    @current_card    = get_next_card
    @played_cards    = Deck.new
    @last_response   = nil
  end

  def play!
    @view.welcome_message

    until game_finished?(@last_response)
      @view.render(read_current_card)
      @last_response = @view.get_response
      
      if correct_answer?(@last_response)
        @view.correct_response
        file_card
        @current_card = get_next_card
      elsif @last_response != LEAVE_RESPONSE
        @view.incorrect_response
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

  def correct_answer?(answer)
    @current_card.correct_answer?(answer)
  end

  def game_finished?(response)
    response == LEAVE_RESPONSE || @deck.empty?
  end

  def exit
    if @deck.empty?
      @view.exit_message
    else
      @view.quit_message
    end
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
    gets.chomp.strip.downcase
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

parser = CardParser.new('sample_cards.csv')
deck   = Deck.new(parser.cards)
game   = FlashCardController.new(deck)

game.play!