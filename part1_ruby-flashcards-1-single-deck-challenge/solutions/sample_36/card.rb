class Card 
  attr_reader :def, :term
  def initialize(array)
    @def = array[0]
    @term = array[1]
  end

  def match?(input)
    input == @term.downcase
  end

end
