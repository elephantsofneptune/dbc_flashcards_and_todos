class FlashCard
  attr_reader :term, :definition
  attr_accessor :complexity

  def initialize(text)
    @definition = text[0] 
    @term = text[1]
    @complexity = 0
  end

  def match?(guess)
    @complexity += 1
    @term == guess
  end

  # def to_s
  #   "#{@term} \n\t #{@definition}"
  # end
end

class Deck
  attr_reader :cards
  def initialize(file)
    @cards = []
    create_deck(file)
    shuffle
    @done = []
  end

  def create_deck(file)
    lines_array = File.readlines(file,"\n\n").map { |a| a.split("\n") }
    lines_array.each { |pair| @cards << FlashCard.new(pair) }
  end

  def shuffle
    @cards.shuffle!
  end

  def pick
    @done << @cards.pop
    p @done
    @done.last
  end

  def trickiest
    @done[0..-2].sort_by{|card| card.complexity}[-3..-1]
  end

  def print_trickiest
    trickiest.each do |card|
      puts card.definition
    end
  end
end


# deck = Deck.new('flashcard_samples.txt')
