class Deck
  attr_reader :card_db

  def initialize(filename)
    @card_db = []
    parse(filename)
  end

  def correct?(user_answer, actual_answer)
    user_answer == actual_answer
  end

  def parse(filename)
    array = File.readlines(filename, :quote_char => "\x00").map do |line|
      line.split("\n").delete_if {|string| string == " " } 
    end
    array.delete_if {|item| item == []}
    hash = Hash[*array.flatten]
    hash.each {|k, v| @card_db << Card.new(k,v) }
  end

end

class Card
  attr_reader :definition, :answer

  def initialize(definition, answer)
    @definition = definition
    @answer = answer
  end
end
