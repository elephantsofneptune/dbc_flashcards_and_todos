class View
  def self.welcome
		puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!
  			  Please type 'Q' to exit"
  		puts ""
	end

	def self.definition(flashcard)
		puts "\nDefinition"
    	puts flashcard.definition
    	puts ""
	end

	def self.goodbye
		puts "Thanks for playing and studying!"
		puts ""
	end

	def self.correct
		puts "OMG! That is CORRECT!"
		puts ""
	end

	def self.guess
		puts "Guess word:"
	end

	def self.guess_again
		puts "Wrong answer. Please guess again:"
	end
end