# *** MODEL ***
class Flashcard
  attr_reader :word, :definition

  def initialize(definition, word)
    @word = word
    @definition = definition
  end
end



