
#puts "Welcome to the 'Spectacular RJD Flashcard game'!"
#puts "Which one would you like to play?"
#puts #All of the different options(Gameoptions Array)
#game_selected = gets.chomp.downcase
#
# new_flashcard_game = Flashcard.new(game_selected)
require_relative 'flashcard_model'
require_relative 'flashcard_view'

deck_path = "./decks/"

view = DeckViewer.new

view.game_welcome_message

deck_selection = nil
until deck_selection == "exit"
  constructor = DeckConstructor.new
  view.ask_deck_to_play
  view.display_deck_options(constructor.find_decks(deck_path))
  deck_selection = gets.chomp
  if deck_selection == "exit"
    break
  end
  csv_file = deck_path + deck_selection + ".csv"

  deck = CardDeck.new({:deck_name => deck_selection, :card_array => constructor.populate_deck(csv_file)})
  
  repeat_deck_answer = nil
  view.deck_welcome_message(deck)
  until deck.all_terms_guessed
    view.display_card_definition(deck.current_card)
    guess = gets.chomp
    if guess == deck.current_term
      deck.card_guessed_correctly
      view.display_card_guessed_correctly
    else
      deck.card_guessed_incorrectly
      view.display_card_guessed_incorrectly
    end 
  end
  view.display_all_cards_guessed
end
view.display_exit_game_message
