require_relative 'flashcards'

class Deck

  attr_reader :deck

  def initialize(file)
    @flashcard_list = File.readlines(file) # moved the file grab to the initilaize method
    # to reduce redunant behaviour.  Plus, this happens only during initialize so 
    # it made sense to not do it in the parse_file method.
    @deck = []
    create_card
  end

  # I wrapped the following parse_file into the below method because they are 
  # really doing one task and that is to read the array and make a new card object.  

  # def parse_file
  #   until @flashcard_list.empty?
  #     create_card(@flashcard_list.shift(3))
  #   end
  # end

  # def create_card(arr)
  #   description = arr[0].delete("\n")
  #   answer = arr[1].delete("\n")
  #   @deck << FlashCard.new({description: description, answer: answer})
  # end

  # I refactored the code above into the method below.  The description and answer variables
  # were telling the same story as the hash symbols description and answer.  I moved them into the 
  # 

  def create_card
    until @flashcard_list.empty?
      new_card = @flashcard_list.shift(3)
      @deck << FlashCard.new( { description: new_card[0], answer: new_card[1].delete("\n") } )
    end
  end


  # def get_card
  #  @deck.shuffle!
  #  @deck.find { |card| card.marked? == false }
  # end

 # The above method was doing two things that could be joined together without
 # and real readability loss.  It became the method below.  

  def get_card 
   @deck.shuffle!.find { |card| card.marked == false }
  end

  # def cards_left?
  #   @deck.find { |card| card.marked? == false } ? true : false
  # end

  # the method above didn't actually require a block of code since we are 
  # using the actual true and false objects in ruby.  I found on 
  # rdocs "If the block is not given, Ruby adds an implicit block of 
  #{ |obj| obj } which will cause all? to return true when none of the 
  # collection members are false or nil." In this case we only needed 
  # @deck.all? to say true when there were no longer any false conditions
  # left in the deck.  

  def cards_left?
    @deck.all?
  end
end
