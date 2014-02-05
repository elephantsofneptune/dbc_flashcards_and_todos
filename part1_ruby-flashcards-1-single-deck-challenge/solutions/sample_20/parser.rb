class Parser
  attr_reader :file, :deck
  def initialize(filename)
    @file = filename
    parse_text
  end


  def parse_text
    new_array = []
    @deck = Deck.new
    File.foreach(self.file) do |line|
      new_array << line.chomp
    end
    new_array.delete_if { |element| element ==  " "}.each_slice(2).to_a.each do |inner_array|
      if inner_array[0].nil? or inner_array[1].nil?
        raise "Invalid Deck!" 
      end
      @deck.add_card(Card.new(inner_array[0], inner_array[1]))
    end
  end
end
