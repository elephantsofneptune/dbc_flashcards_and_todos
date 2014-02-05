require_relative 'flashcard'
require_relative 'deck'
require_relative 'view'


def play_round(deck)
  @incorrect_answers = []                                          
  flashcard = deck.sample
  guess = View.question_guess_prompt(flashcard.question)

  until guess == 'quit' || deck.out_of_cards?

    until flashcard.correct?(guess) || guess == 'skip'    
      guess = View.incorrect_guess_prompt
      @incorrect_answers << flashcard
    end

    if guess == 'skip'
      response = View.skip_prompt(flashcard.answer) 
      break if response == 'quit'
    else
      View.correct_answer
    end
    
    flashcard = deck.sample
    guess = View.question_guess_prompt(flashcard.question)
  end
end

View.welcome
play_round(Deck.new(filename: ARGV[0]))

View.review_prompt
response = STDIN.gets.chomp

if response == 'yes'
  play_round(Deck.new(card_array: @incorrect_answers.uniq))
end

View.end

