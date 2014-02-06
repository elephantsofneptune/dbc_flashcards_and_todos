module Display
  def reputs(str = '')
    puts "\e[0K" + str
  end
   
  # Clear the screen
  def clear_screen!
    print "\e[2J"
  end
   
  # Moves cursor to the top left of the terminal
  def move_to_home!
    print "\e[H"
  end
   
  # Flushes the STDOUT buffer.
  # By default STDOUT is only flushed when it encounters a newline (\n) character
  def flush!
    $stdout.flush
  end

  def clear_and_home!
    clear_screen!
    move_to_home!
  end
end

module TextParser
  def raw_to_flashcard_data(text)
    data = text.read.split(/\n *\n/)
    data.map do |question_answer|
      question, answer = question_answer.split(/\n/)
      Hash[:question => question, :answer => answer]
    end
  end
end

class Game
  include Display

  @@width = 50

  def initialize
  end

  def start
    clear_and_home!
  end
end

class FlashCards < Game
  ATTEMPTS = 3
  EXIT = 'quit'

  def initialize
    super()
    @cards = []
    @correct = 0
    @total = 0
  end

  def start
    super

    puts "#" * @@width << "#"
    puts "#            Welcome to FlashCardz".ljust(@@width) << "#"
    puts "#" * @@width << "#\n\n"

    input = nil
    until input == EXIT
      card = show_card @cards.sample
      attempts = 0

      until attempts >= ATTEMPTS
        input = gets.chomp.strip
        break if input == card.answer || input == EXIT
        puts "\nINCORRECT, :(\n"
        attempts += 1
      end

      break if input == EXIT

      if attempts >= ATTEMPTS
        puts "\nThat's #{ATTEMPTS} wrongs answers, so let's just move on\n"
      else
        puts "\nCORRECT!!!\n"
        @correct += 1
      end

      @total += 1

      sleep(2)
      clear_and_home!

      puts "Current Score: #{(@correct / @total.to_f * 100).round(0)}%\n\n"
    end
  end

  def show_card(card)
    puts "#" * @@width << "#"
    3.times { puts "#".ljust(@@width) << "#" }
    card.question_lines(@@width - 10).each { |line| puts "#    #{line}".ljust(@@width) << "#" }
    3.times { puts "#".ljust(@@width) << "#" }
    puts "#" * @@width << "#\n\n"
    return card
  end

  def add_card(card)
    @cards << Card.new(card)
  end

  def add_cards(cards)
    cards.each do |card|
      add_card card
    end
  end

  def to_s
    @cards.map {|card| card.to_s }.join("\n")
  end
end

class Card
  attr_reader :question, :answer

  def initialize(question_answer)
    @question = question_answer[:question]
    @answer = question_answer[:answer]    
  end

  def question_lines(line_length)
    char_index = 0
    question = []
    while char_index < @question.length
      question << @question[char_index...char_index + line_length]
      char_index += line_length
    end
    question
  end
end

include TextParser

flashcard_data = TextParser.raw_to_flashcard_data(File.open('data.txt'))

game = FlashCards.new
game.add_cards(flashcard_data)
game.start
