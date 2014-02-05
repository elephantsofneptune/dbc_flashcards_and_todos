class FlashCard

  attr_reader :description, :answer, :marked
  # attr_accessor :marked - marked did not need to be an accessor, so I changed it to a reader.
  # when I did that I also noticed that the marked? method was redundant and could be removed if 
  # I changed any calls from marked? to marked without a questionmark.

  def initialize(flashcard) # changed "args" to "flashcards" because it reads better.
    @description = flashcard[:description]
    @answer = flashcard[:answer]
    @marked = flashcard[:marked] || false
  end

  def guess_correct?(guess)
    @answer == guess
  end

  def mark!
    @marked = true
  end

  # def marked? # removed question mark and moved to a reader :marked
  #   @marked
  # end
end