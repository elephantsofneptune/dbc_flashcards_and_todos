require_relative 'deck'

class Card

  attr_reader :term, :definition 
  attr_accessor :attempts
  
  def initialize(definition, term)
    @definition = definition
    @term = term
    @status = false
    @attempts = 0 
  end

  def increment_attempt
    @attempts += 1
  end

  def completed?
    @status == true
  end

  def completed!
    @status = true
  end
end


