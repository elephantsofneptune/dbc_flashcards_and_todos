class Storage
   attr_reader :decks
	def initialize
		@decks = {}
	end

	def save(name, element)
		@decks.merge!({name => element})
		#@deck
	end

	def open(name)
		@decks[name]
	end
end


class CardDeck
	attr_reader :current_deck
	def initialize(storage = Storage.new)
		@storage = storage
	end

	
	
	def add(deck)
		@storage.save(deck, formatted_deck(deck))
	end

	def accessible?(deck)
		@current_deck = deck
		@storage.decks.has_key?(deck)
	end

	def play
		@storage.open(@current_deck).each do |word, definition|
			puts "----------------------------"
			puts "#{definition}\nHint>>#{word}"
			puts "----------------------------"
			begin
				puts "Enter Correct Definition"
				input = gets.chomp
				if input == "quit"
					puts "You have exited the game. Seya later"
					return 0
				end
			end while input != word 

			puts "Correct! Next word..."
		end
	end

# #### debugging Methods
# 	def access(deck)
# 		@storage.open(deck)
# 	end

	def view_all_decks
		@storage.decks.each_key { |name| puts name}
	end

	private 
	def parse(deck)
		storage = []
		File.open(deck).each_with_index do |row, index|
			print row + "\n"
			storage << row
		end
		storage.reverse
	end

	def formatted_deck(deck)
		removed_lines = parse(deck).reject { |row| row == "\n" || row == " \n"}
		removed_lines.map! { |row| row.chomp }
		Hash[*removed_lines]
	end

end

class GameFlow
	def start!
		gm = CardDeck.new
		gm.add("flashcards1.txt")
		gm.add("flashcards2.txt")
		puts "Please select a deck\n"
		gm.view_all_decks
		
		until gm.accessible?(gets.chomp)
			puts "Deck does not exist"
		end


		puts "You are now playing #{gm.current_deck}"
		puts "Welcome to Ruby Flash Cards. To play, enter the correct term for each definition."
		puts "Type (quit) to exit"
		gm.play
	
		
	


		
		
		# begin
		# 	#get storage and iterate
			
		# 	puts "Definition > "
		# 	puts "Guess > "
		# 	input = gets.chomp
		
		#end while input != "exit"
		puts "\n\nSee you next time!"
	end
end

GameFlow.new.start!

# cd = CardDeck.new
# p cd.add("flashcards1.txt")
# p cd.add("flashcards2.txt")
# p ">>>>>>>>>>>>>>"
# #p cd.view_all_decks
# #p cd.access("flashcards1.txt")
# p cd.accessible?("flashcards1.txt")
# p cd.access("flashcards1.txt")
# p cd.play("flashcards1.txt")
