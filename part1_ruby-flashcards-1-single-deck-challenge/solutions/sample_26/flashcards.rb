class View
  def welcome!
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
    puts "Type 'quit' to quit and 'skip' to skip to the next card"
  end

  def print_definition(card)
    puts card.definition
  end

  def incorrect
    puts "WHATTT!"
  end

  def display_skip_message
    puts "You are skipping to the next card"
  end

  def correct
    puts "YEEEEAH!!!!"
  end
end



class CardDeck
  attr_reader :deck_of_cards, :deck
  def initialize
    @deck = load_data_file
    @deck_of_cards = generate_cards
  end
  def load_data_file
    array = []
    File.foreach("flashcard_samples.txt") do |row|  
      array << row
    end
    array - ["\n"]
  end
  def generate_cards
    array = []
    deck.each_with_index do |item, index|
      if index.odd?
        current_def = deck[index-1]
        array << Card.new(current_def,item)
      end
    end
    array
  end

end

class Card
  attr_reader :definition, :ans
  def initialize(definition, ans)
    @definition = definition 
    @ans = ans.strip  
  end
end

class Controller
  def initialize
    @card_deck = CardDeck.new.deck_of_cards
    @view = View.new
    @user_input = nil
    @still_playing = true
    @answer_correct = false
  end

  def start
    @view.welcome!
    play
  end

  def play
    card = 0
    while @still_playing
      #@view.print_definition(@card_deck[card].definition)
      @view.print_definition(@card_deck[card])
      @user_input = gets.chomp
      parse_input(card)
      if @answer_correct
        card == (@card_deck.length - 1) ? card = 0 : card += 1
      end
    end
  end

  def parse_input(card)
    case @user_input
    when "quit" then @still_playing = false
    when "skip"
      @view.display_skip_message
      @answer_correct = true
    when @card_deck[card].ans
      @view.correct
      @answer_correct = true
    else 
      @view.incorrect 
      @answer_correct = false
    end   
  end
end

game = Controller.new
game.start