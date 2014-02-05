class Dictionary # cool, now I have a working hash as my dictionary
	attr_reader :entries_for_flashcards
	
	def initialize(file)
		@file = file
		self.create_dictionary
	end

	def create_dictionary # organized by { word => def, word => def}
		main_entries = []
    	File.open(@file, "rb") do |file|
			file.lines.each do |line|
				main_entries << line
			end
		end
		main_entries.map! { |entry| entry.chomp }
		@entries_for_flashcards = Hash[*main_entries.reverse.flatten]
	end
end

class Flashcard # makes the flashcards by sampling from the dictionary
	attr_reader :word, :definition
	def initialize(file)
		@file = file
		@dictionary = Dictionary.new(@file)
		@word = @dictionary.entries_for_flashcards.keys.sample
		@definition = @dictionary.entries_for_flashcards[@word]
	end
end

class Game
	attr_reader :flash_card

	def initialize(file)
		@file = file
	end

	def welcome!
		puts "Welcome to Ruby Flashcards, your own personal Ruby vocabulary builder \\(^o^)/"
		puts ""
		puts "Rules:"
		puts "-- Guess the proper Ruby term for each definition."
		puts "-- Spelling counts!!!"
		puts "-- You only have one chance to guess the word."
		puts ""
	end

	def run!
		welcome!
		loop do
			self.new_flashcard
		
			puts "Definition: #{self.flash_card.definition}"
		
			puts "Enter your guess!"
			puts ""

			get_input!
			
			puts ""
		end
	end

	def get_input!
		user_input = gets.chomp
		
		if self.correct_guess?(user_input) == true
			puts "Correct!"
		elsif user_input == "quit"
			exit
		elsif user_input == ""
			get_input!
		else 
			puts "Incorrect (>.<)"
			puts "Correct answer: #{self.flash_card.word}"
		end
	end

	def new_flashcard
		@flash_card = Flashcard.new(@file)
	end

	def correct_guess?(guess)
		# checks hash to see if the guess matches the definition
		guess == @flash_card.word
	end
end

game = Game.new('sampler.txt')
game.run!