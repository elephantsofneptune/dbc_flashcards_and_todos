# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-07-06T05:27:49+00:00
class DeckViewer

  def game_welcome_message
    title = File.read('title.txt')
     puts title
     puts "RJD Flashcard game!"
     puts "-----------------------------------------------"
  end

  def ask_deck_to_play
    puts "Enter the name of the deck you'd like to play. If you prefer to exit, enter \"exit\""
  end

  def display_deck_options(decks_arr)
    decks_arr.each do |deck|
      puts "#{deck}"
      sleep(1.0)
    end
  end

  def deck_welcome_message(deck)
    puts "Welcome to #{deck.name}! To advance, enter the correct term for each definition."
    puts "Let's get ready to rumble!!!!"
    puts
  end

  def display_card_definition(card)
    puts " _______________________________________________________________________________" 
    puts "|                                                                               |"
    puts "| " + "Current Definition".center(77)+ " |"
    puts "| ______________________________________________________________________________|"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "| " + card.definition.center(77) + " |"                                      
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|                                                                               |"
    puts "|_______________________________________________________________________________|"
    puts "Enter term:"
  end

  def display_card_guessed_correctly
    puts "Correct!"
  end

  def display_card_guessed_incorrectly
    puts "Nope, got it wrong. On to the next card!"
  end

  def display_all_cards_guessed
    puts "Congratulations, you've completed all the cards!"
    sleep(1.0)
    puts
  end

  def display_exit_game_message
    puts "Exiting the flashcard program. Have a nice day!"
  end
end
