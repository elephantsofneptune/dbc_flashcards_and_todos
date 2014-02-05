# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-08-17T06:56:41+00:00
class Card

	attr_reader :question, :answer

	def initialize(question, answer)
		@question = question
		@answer = answer
	end
end

class Deck

	attr_reader :source_file, :cards, :card

	def initialize(source_file, view = View.new)
		@source_file = source_file
		@cards = []
		@view = view
	end

	def setup_game
		parse_file
		hashify(@parsed_content)
		generate_cards	
	end

	def start_game
		setup_game
		@view.welcome
		until game_finished?
			pick_a_card
			@view.ask_question(@card.question)
			@view.provide_answer(@card.answer)
			
			case user_input
			when @card.answer
				@view.correct
			else
				@view.incorrect unless @cards.size == 0
			end
		end
		
	end

	def pick_a_card
		@card = @cards.shift
	end

	def game_finished?
		@cards.empty?
	end

	def user_input
		gets.chomp
	end

	def parse_file
		@parsed_content = File.readlines(source_file).delete_if {|item| item == " \n"}.map {|item| item.chomp}
	end

	def hashify(content)
		@hashified_content = Hash[*content]
	end

	def generate_cards
		@hashified_content.each {|question, answer| @cards << Card.new(question, answer)}
	end

end

class View
	def welcome
		puts "Welcome to Ruby Flashcards!"
	end

	def ask_question(question)
		puts question
	end

	def provide_answer(answer)
		puts answer
	end

	def correct
		puts "Correct!"
	end

	def incorrect
		puts "Incorrect! Try another question."
	end

end

new_deck = Deck.new('flashcard_samples.txt')

new_deck.start_game
