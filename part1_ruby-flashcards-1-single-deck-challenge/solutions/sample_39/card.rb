class Card
  attr_reader :answer, :definition
  #i: hash from the controller with the list of strings 
  def initialize(args)
    @answer = args[:answer]
    @definition = args[:definition]
  end
  #o: a card object
end