require_relative 'parser.rb'
require_relative 'ui.rb'
require_relative 'card.rb'
require_relative 'deck.rb'


class Controller
  attr_reader :parser, :deck, :view, :current_card, :guess
  def initialize(filename)
    @parser = Parser.new(filename)
    @view = UI.new
    @deck = self.parser.deck
    loop_game
  end

  def loop_game
    self.deck.shuffle!
    until self.deck.cards.empty?
      exit_clause = game_steps
      return "EXIT" if exit_clause == "EXIT"
    end
    most_attempted = self.deck.most_attempts
    self.view.display_most_attempted(most_attempted.reverse)
    self.view.game_over
  end

  def game_steps
    get_card
    show_current_definition
    retrieve_guess #cases matter
    complete_card
  end

  def complete_card
    until self.current_card.completed?
      return "EXIT" if self.guess == "EXIT"
      if check_guess == true
        self.current_card.increment_attempt
        self.view.correct_answer(self.guess)
        self.current_card.completed!
      else
        self.current_card.increment_attempt
        self.view.wrong_answer(self.guess, self.current_card)
        retrieve_guess
      end
    end
  end

  def check_guess
    self.guess == self.current_card.term
  end

  def retrieve_guess
    @guess = self.view.retrieve_guess 
  end


  def show_current_definition
    self.view.display_def(self.current_card)
  end

  def get_card
    @current_card = self.deck.next_card
  end
end

