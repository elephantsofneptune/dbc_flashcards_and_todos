require 'csv'
class FlashCard
  attr_reader :definition, :answer, :in_the_deck

  def initialize(definition = "", answer = "")
    @answer = answer
    @definition = definition
    @in_the_deck = true
  end
  
  def self.compare_guess_answer(guess, deck)
    guess = guess.downcase
   
    if guess == deck.card_objects[deck.curr_card].answer
      in_the_deck = false   
      UserInterface.correct(guess)
    else 
       UserInterface.wrong(guess)
        deck.curr_card +=1
    end
  end 
end 


class Deck
  attr_reader :card_objects
  attr_accessor :curr_card

  def initialize(hash_1)
    @card_objects = make_deck(hash_1)
    @curr_card = 0
  end  

  def make_deck(hash_1)
      hash_1.map{ |definition, answer| FlashCard.new(definition,answer) } 
  end

  def remove_correct_answers(deck)
    @card_objects.delete(deck.card_objects[deck.curr_card])
  end 

  def shuffle_cards
    @card_objects.shuffle
  end

  def return_score
    100 - @card_objects.length  # 100 = hash length
  end
end 


class Flashcard_Parser
  
  def self.parse(file)
    place_holder = []
    
    File.open(file,'r').each_line do |line|
      if line != "\n"
        place_holder << line
      end
    end

    parsed_text = Hash[*place_holder]
    return parsed_text
  end
end

######CONTROLLER######

class Study
 
  def start!
    flash_hash = Flashcard_Parser.parse('flashcard_samples.txt')
    deck = Deck.new(flash_hash)
    user_choice = 'c'
    until user_choice == 'q' || deck.card_objects.length == 0
      UserInterface.welcome
      UserInterface.render_definition(deck)
      UserInterface.prompt_for_guess
      guess = gets
      FlashCard.compare_guess_answer(guess, deck)
      deck.remove_correct_answers(deck)
      UserInterface.display_options
      user_choice = gets.chomp.downcase
    end
  end

end


class UserInterface
  def self.welcome
    puts "get ready to learn!"
  end

  def self.render_definition(deck)
    puts deck.card_objects[deck.curr_card].definition
  end
  
  def self.display_options 
    puts "Quit[q] or Continue[c]?"

  end 

  def self.prompt_for_guess
    puts "Enter a guess:"
  end

  def self.correct(guess)
    puts "#{guess} was right, Nice Job!"
  end

  def self.wrong(guess)
    puts "#{guess} was wrong"
  end

end


current_study_sesh = Study.new
current_study_sesh.start!
