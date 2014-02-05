class Input

  attr_reader :raw_data, :card_fronts, :card_backs, :file
  
  def initialize(file)
    @raw_data = File.open(file).readlines
    (@raw_data.length - 1).times { |i| @raw_data[i].delete!("\n") }
    @card_fronts = []
    @card_backs = []
    self.format
  end

  def format
    @raw_data.reject! { |i| i.empty? }
    @raw_data.each_with_index { |text, index| @card_fronts << text if index.even? }
    @raw_data.each_with_index { |text, index| @card_backs << text if index.odd? }
  end
end

class Card

  attr_reader :file, :random_card

  def initialize(file)
    @input = Input.new(file)
    @random_card = random_card
    self.random
  end

  def random
    @input.card_fronts.length
    random_index = rand(0..@input.card_fronts.length-1)
    @random_card = [@input.card_fronts[random_index], @input.card_backs[random_index]]
  end
end

class Game

  BREAK = "========================================"
  def initialize(file)
    @card = Card.new(file)
  end

  def run!
    puts "Welcome to Ruby Flash Cards.  To play, just enter the correct term for each definition."
    puts "Type 'RUN' to play, or 'E' to exit at anytime"
    answer1 = gets.chomp
    if answer1.upcase == 'RUN'
      answer = "hi"
      until answer.upcase == 'E'
        puts "\n" + BREAK
        @card.random
        puts  "Name the " + @card.random_card[0]
        puts "hint:   #{@card.random_card[1]}"
        answer = gets.chomp
        if answer.downcase == @card.random_card[1].downcase
          puts "\n" + BREAK
          puts "too easy?! try another"
        else
          puts "\n" + BREAK
          puts "Try again!"
        end
      end
    elsif answer1.upcase == 'E'
      exit 
    else
      "try again"
    end
  end
end 

game = Game.new('sample_cards.txt')
puts game.run!






# create one class FlashCards to handle everything
#   define method fetch to pull readlines on txt file
#     store each card in an array
#     store each answer in an array
#   end 
#   define method randomly select to randomly select a card for the game
#     randomly selects a card, and it's answer
#   end
#   define run
#     handles command line interface
#   end

# create one class input which handles the fetching and formatting of information

# create another class that handles the creation of a random card from the input class

# create another game class that handles the game running