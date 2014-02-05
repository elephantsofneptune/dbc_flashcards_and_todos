require_relative 'flashcard_model.rb'
require_relative 'db_module'
require 'pry'

class Game
  # include CSVFormat

  attr_reader :deck

  def initialize
    @deck = []
  end

  def save(args)
    # calls module to save game data to DB
    FlashCardDatabase::CSVFormat.save_to({file: args[:file], cards: @deck})
  end

  def load(args)
    # calls module to parse game data from DB, and create cards
    puts "this should be executing"
    FlashCardDatabase::CSVFormat.parse_to(args).each do |row|
      add_card(row)
    end
  end

  def add_card(args)
    #initialize card with information passed from controller
    @deck << FlashCard.new(args)
  end

end

# game = Game.new
# # game.add_card(term: "foo", definition: "bar")
# # game.add_card(term: "baz", definition: "buzz")

# binding.pry
