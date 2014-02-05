# what attrs do we want this to have? what behaviors?
class FlashCard
  attr_reader :definition, :term
  def initialize(args)
    @term, @definition = args[:term], args[:definition]
  end

  def correct?(guess)
    guess == @term
  end
end


# Test to make sure correct works and FlashCard is instantiated

instance_variable = {term: "instance variable", definition: "a variable that each instance has"}
a = FlashCard.new(instance_variable)
puts a.correct?("instance variable") == true

