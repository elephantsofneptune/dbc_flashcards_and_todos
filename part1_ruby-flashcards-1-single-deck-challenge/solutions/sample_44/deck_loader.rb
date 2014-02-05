require_relative 'flashcard.rb'
require_relative 'deck.rb'



class DeckLoader
  # loads a deck full of flashcard objects :)
  def self.load_deck(file_name)
    attributes = retrieve_definitions_and_terms(file_name)
    create_flashcards(attributes)
  end

  # parse file and extract definitions and terms
  def self.retrieve_definitions_and_terms(file_name)
    definitions     = []
    terms           = []
    f = File.new(file_name)
    f.readlines.each_with_index do |line, index|
      definitions << line.chomp if index % 3 == 0
      terms       << line.chomp if index % 3 == 1
    end
    definitions.zip(terms)
  end

   # create flashcard objects from attributes
   # add to deck
   # return deck
  def self.create_flashcards(attributes)
   flash_card_deck = Deck.new # empty array
   attributes.each do |definition, term|
     flash_card_deck << Flashcard.new(definition, term)
   end

   flash_card_deck
  end
end
