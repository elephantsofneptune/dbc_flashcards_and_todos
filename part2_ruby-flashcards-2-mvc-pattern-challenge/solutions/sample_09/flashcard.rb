class FlashCard  
  attr_reader :question, :answer, :attempts
  def initialize(question, answer)
    @question = question
    @answer = answer    
    # @attempts = 0
  end

  def correct?(guess)
    # @attempts += 1 unless @answer == guess
    @answer.downcase == guess.downcase
  end

end
