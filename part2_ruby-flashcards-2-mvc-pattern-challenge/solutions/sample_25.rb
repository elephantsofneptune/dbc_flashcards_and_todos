class FlashModel
  attr_reader :contents, :cards

  def initialize(file)
    @contents = read_from_file(file)
  end

  def read_from_file(file)
    open(file) {|f| f.readlines}
  end

  def create_cards
    cards = []
    @contents.each_slice(3) do |qa_pair|
      cards << FlashCard.new(qa_pair[0].strip, qa_pair[1].strip.upcase, 1, false)
    end
    cards
  end

end

class FlashCard < Struct.new(:question, :answer, :tries, :answered)
end

class FlashController

  MAX_GUESSES = 3

  def initialize(file)
    @model = FlashModel.new(file)
    @view = FlashView.new
    @view.welcome_message(file)
  end

  def play_game
    @num_correct = 0
    cards = @model.create_cards.shuffle
    cards.each {|card| guess(card) unless card.answered} until cards.all? {|card| card.answered}
    @view.game_over_message(@num_correct, cards)
  end

  def guess(card)
    tries = 0
    correct = false
    @view.ask_question(card.question)
    until tries >= MAX_GUESSES || correct   #DISASTER
      @view.try_again unless tries.zero?
      user_input = STDIN.gets.chomp.upcase
      correct = (user_input == card.answer)
      @view.respond_to_answer(correct)
      card.tries += 1 unless correct
      tries += 1
      card.answered = true if correct && tries == 1
    end
    @view.reveal(card.answer) if tries == MAX_GUESSES
  end

end

class FlashView

  def ask_question(question)
    puts question
    print "Your answer: "
  end

  def respond_to_answer(right_or_wrong)
    puts right_or_wrong ? "Well done!" : "Nope!"
  end

  def try_again
    print "Try again: "
  end

  def game_over_message(num_correct, cards)
    puts
    puts "=======GAME OVER======="
    puts "Your results:"
    cards.each do |card|
      puts "#{card.answer.upcase} took you #{card.tries} tries."
      puts
    end
  end

  def reveal(answer)
    puts "The answer to the question is '#{answer}'"
  end

  def welcome_message(file)
    puts "Welcome to Ruby Flash Cards! You are using the deck '#{file}.'"
    puts
  end

end


controller = FlashController.new(ARGV.first)


controller.play_game
