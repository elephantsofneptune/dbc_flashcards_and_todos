require_relative 'deck'

module Viewer

MESSAGES = {
  :succeed => 'Well done',
  :fail => "Nope!\nAnother chance or you 'give up'?\n",
  :guess => "\nWhat is your guess?\n",
  :final => "The hardest question for you was:\n"
}

  def move_to_home!
    print "\e[H"
  end
  
  def clear_screen!
    print "\e[2J"
  end

  def welcome
    clear_screen!
    move_to_home!
    printer("Welcome to Ruby Flash Cards (TM)! We hope you enjoy the game!")
  end

  def goodbye
    printer("\nCongratulations, you finished the deck!\n")
  end

  def printer(string)
    string.split(//).each do |letter|
      print letter
      sleep(0.02)
    end
  end

  def prompt(key)
    printer(MESSAGES[key])
  end

end


class UserInterface

  include Viewer

  def initialize(source)
    @deck = Deck.new(source)
  end

  def run
    welcome
    card = @deck.pick
    play(card)
    see_hardest
    goodbye
  end

  def play(card)
    until card == nil
      play_card(card)
      card = @deck.pick
      clear_screen!
      move_to_home!
    end
  end

  def play_card(card)
    display_def(card)
    @user_patience = 'ok'
    until @user_patience == 'give up'
      check_card(card)
    end
  end

  def check_card(card)
    if card.match?(ask_guess)
      prompt(:succeed)
      sleep(1)
      @user_patience = 'give up'
      return
    else
      prompt(:fail)
      @user_patience = ask_user
      if @user_patience == 'give up'
        printer("The solution was #{card.term}")
        sleep (2)
      end
    end
  end
  
  def display_def(card)
    printer("\nDefinition:\n\n#{card.definition}\n")
  end

  def ask_guess
    prompt(:guess)
    ask_user
  end

  def ask_user
    STDIN.gets.chomp
  end

  def see_hardest
    prompt(:final)
    @deck.print_trickiest
  end

end
game = UserInterface.new(ARGV[0])
game.run