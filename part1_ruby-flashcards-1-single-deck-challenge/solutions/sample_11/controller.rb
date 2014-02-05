require "./model.rb"
require "./view.rb"
require "./database_reader.rb"

class Controller
  attr_reader :my_deck, :my_view

  def initialize
    @my_deck = Deck.new
    @my_view = View.new
    @my_DB = DatabaseReader.new('flashcards.csv')
    @my_DB.populate(@my_deck)
    my_view.clear_screen!
    my_view.move_to_home!
    @streak = 0
  end
  def deck_manager
    puts 
  end
  
  def run!
    my_view.clear_screen!
    my_view.move_to_home!
    my_view.welcome_screen
    my_view.instructions
    puts "Your current streak is: #{@streak}!" if @streak > 1
    puts my_view.show_definition(my_deck.get_card)
    response = gets.chomp
    if evaluate(response)
      my_view.correct_answer
      @streak += 1
      sleep(1.75)
      my_deck.next_card!
      run!
    elsif response == 'delete card'
      my_deck.print_deck
      puts ""
      puts "Which number would you like to delete?"
      card_index = gets.chomp.to_i - 1
      puts "Are you sure you would like to delete '#{my_deck.card_deck[card_index].definition}'?"
      puts "Type 'yes' or 'no'"
      gets.chomp == 'yes' ? my_deck.delete_card(card_index) : run!
      my_deck.print_deck
      my_deck.next_card!
      sleep(4)
      run!
    elsif response == 'shuffle'
      my_view.show_answer(my_deck.get_card)  
      sleep(1.75)
      my_deck.shuffle
      my_deck.next_card!
      @streak = 0
      run!
    elsif response == 'exit' || response == 'quit' 
      @my_DB.save_csv(my_deck.card_deck)
      return
    elsif response == 'add card'
      puts "Type in definition:"
      definition = gets.chomp
      puts "Type in answer:"
      answer = gets.chomp
      my_deck.add_card(Card.new(definition, answer))
      my_deck.next_card!
      run!
    else
      my_view.guess_again
      sleep(2)
      @streak = 0
      run!
    end
  end

  def evaluate(answer)
    return true if answer.downcase == my_deck.get_card.answer.downcase
    false
  end

end

my_controller = Controller.new
my_controller.deck_manager
my_controller.run!

