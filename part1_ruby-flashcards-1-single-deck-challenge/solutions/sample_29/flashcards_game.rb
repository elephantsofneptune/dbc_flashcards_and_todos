
require_relative 'util'
require_relative 'card'

class Game
include Util
  
  attr_reader :deck

  def initialize(file_name)
    @deck = parse_text(file_name)
  end

  def play
    until @deck.empty? 
      run_game    
    end
  end 

  def game_over?
    @deck.empty?
  end

  def check_answer (card, guess)
    card.term == guess
  end

  def get_card
    random_card = @deck.sample
  end

  def remove_card (card)
    self.remove(card)
  end

  def get_guess
    puts "what's your guess?"
    print ":>>"
    input = gets.chomp
  end

# def run_game
#   card = get_card
#   puts card.definition
#   guess = get_guess
#   if check_answer(card, guess) == true
#     puts "Correct!"
#     remove_card(card)
#   else




  def run_turn
   random_card = @deck[0]
   puts random_card.definition
   puts "what's your guess?"
   print ":>>"  
   input = gets.chomp!

     until input == random_card.term 
        puts "sorry! Try again"
        run_turn
      end
        @deck.delete(random_card)
        puts "correct!"
        run_game
    end
  

  def run_game
    card_hash = read_file('card_info.txt')
    deck = build_deck(card_hash)
    puts "*****FLASH||CARDZ*****"
    until self.game_over?
      run_turn
    end 
  end


end

game = Game.new('card_info.txt')

game.run_game






 