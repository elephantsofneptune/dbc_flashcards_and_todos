class Deck
  
  attr_reader :cards

  def initialize(file = "flashcard_samples.txt")
    @cards = []
    @file = file
    import
  end

  def import
    File.new(@file).each_slice(3) do |slice| 
      arr = (slice.map! {|element| element.chomp})
      @cards << Card.new({:definition => arr[0], :answer => arr[1]})
    end
  end

  def select_card
    select_unguessed_card ? select_unguessed_card : select_hardest_cards
  end
  
  def select_unguessed_card
    @cards.find{|card| card.guess_attempts == 0 }
  end
  
  def select_hardest_cards
    sort_by_difficulty
    @cards[rand(-10..-1)]
  end

  def sort_by_difficulty
    @cards.sort_by! { |card| card.guess_attempts }  
  end

end

class Card
  
  attr_reader :definition, :answer
  attr_accessor :correct, :guess_attempts

  def initialize(args)
    @definition = args.fetch(:definition){raise "need card"}
    @answer = args.fetch(:answer){raise "need answer"}
    @correct = false
    @guess_attempts = 0
  end
  
  def check_guess(answer)
    @guess_attempts += 1
    @correct = @answer == answer 
  end
end
