class Deck
  attr_reader :deck

  def initialize(csv_file)
    @csv = csv_file
    @deck = flashcard_deck_parser(@csv).shuffle
    @current_index = 0
  end

  def flashcard_deck_parser(csv)
    deck = []
    flashcards = CSV.foreach(csv, :headers => true, :header_converters => :symbol) do |csv_obj|
      deck << Flashcard.new(csv_obj.to_hash)
    end
    deck
  end

  def current_card
    @deck[@current_index]
  end

  def next_card
    @current_index+=1
  end

  # def term
  #   self[:term]
  # end

  # def definition
  #   self[:definition]
  # end

  def size
    @deck.size
  end

end
