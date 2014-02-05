# Main file for 

class Deck
attr_reader :flashcards
 
def initialize(file_path)
@file_path = file_path
@flashcards = []
create_flashcards_from_parsed_data
end
 
def parse_file_data
file_data = File.open(@file_path)
file_parsed = file_data.read.split("\n").delete_if {|data| data == ''}
end
 
def create_flashcards_from_parsed_data
parse_file_data.each_with_index do |def_and_term, index|
if index%2 == 0
@flashcards << FlashCard.new(parse_file_data[index], parse_file_data[index+1]).to_a
end
end
end
 
end
 
 
class FlashCard
attr_reader :definition, :term
 
def initialize(definition, term)
@definition = definition
@term = term
end
 
def to_a
[definition, term]
end
end
 
module GameText
def self.definition(flashcard)
"Definition:\n#{flashcard}"
end
 
def self.correct
"Advance, child."
end
 
def self.incorrect
"You are an embarrassment to humanity."
end
 
def self.prompt(text)
text
end
 
def self.greeting(game)
"Welcome to the #{game}!\nGuess the answer to the given definition.\nTo skip the definition, type 'skip.'\nTo quit the #{game}, type 'quit.'"
end
 
def self.finisher(game)
"#{game} is finished!\nCongratulations, you are a Jedi master!"
end
end
 
class GameParser
include GameText
 
def self.select(deck)
deck.each do |flashcard|
puts GameText.definition(flashcard[0])
print GameText.prompt(":> ")
user_attempt = gets.chomp
verify(flashcard[0], flashcard[1], user_attempt)
puts GameText.correct
end
puts GameText.finisher("Ruby Flashcards")
end
 
def self.verify(definition, answer, attempt)
 
until answer == attempt || attempt == "skip"
abort("Quitters never win ;)") if attempt == "quit"
puts GameText.incorrect
puts GameText.definition(definition)
print GameText.prompt(":> ")
attempt = gets.chomp
end
end
 
end
 
class Game
def self.run!
puts GameText.greeting("Ruby Flashcards")
trial = Deck.new("flashcard_samples.txt").flashcards.shuffle!
GameParser.select(trial)
end
end
 
Game.run!