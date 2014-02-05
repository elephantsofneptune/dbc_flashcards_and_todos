class FlashCard
  attr_accessor :definition, :ans

  def initialize(args)
    @definition = args[:definition]
    @ans        = args[:ans]
  end

  def match?(input)
    ans == input
  end
end


class Deck
  attr_accessor :cards

  def initialize(args = {})
    @cards = args.fetch(:cards, [])
  end
end


class Parser
  @@deck    = Deck.new
  @@insults = []
  def self.load_cards_from(filename)
    text = []
    File.foreach(filename) { |row| text << row.chomp }

    text.each_slice(3) do |row|
      @@deck.cards << FlashCard.new(definition: row[0], ans: row[1])
    end

    @@deck.cards.shuffle!
  end

  def self.load_insults_from(filename)
    File.foreach(filename) { |row| @@insults << row.chomp }

    @@insults.shuffle!
  end
end
