require_relative 'flashcard_model.rb'
require_relative 'game_model.rb'

# what behaviors
# parse user input
# read a card.definition
# create a new card

class GameController

  def self.run!
    file_name = {file: 'test'} #ARGV[0]
    game = create_game
    game.load(file_name)
    welcome_user(file_name)
    game_options(game, file_name)
    play_game(game)
  end

  def self.create_game
    Game.new
  end

  def self.play_game(game)
    game.deck.each do |card|
      input = ""
      until card.correct?(input)
        display_definition(card)
        input = get_input
        provide_feedback(input, card)
      end
    end
  end

  def self.welcome_user(file_name)
    puts "Welcome to the Best. Game. Ever!"
    puts "Brought to you by Team 2"
    puts "\nYou are working with #{file_name}:"
  end


  def self.game_options(game, file_name)
    print "You can: \n[1] Play the game\n[2] Add a card to game\n[3] Exit\n"
    input = gets.chomp
    if input == "3"
      exit
    elsif input == "2"
      card_args = prompt_for_card_info
      game.add_card(card_args)
      game.save(file_name)
      game_options(game, file_name)
    end
  end

  def self.prompt_for_card_info
    puts "Please enter the card term:"
    term = gets.chomp
    puts "Please enter the card definition:"
    definition = gets.chomp
    {term: term, definition: definition}
  end

  def self.display_definition(card)
    puts card.definition
  end

  def self.get_input
    puts "Enter a guess: (or say: I GIVE UP)"
    gets.chomp
  end

  def self.provide_feedback(input, card)
    return puts "The answer is #{card.term}" if input == "I GIVE UP"
    puts card.correct?(input) ? "Correct!" : "Sorry, try again."
  end
end

GameController.run!

