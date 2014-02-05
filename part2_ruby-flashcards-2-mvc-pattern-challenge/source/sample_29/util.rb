module Util  
def read_file(filename)
    line_array = File.open(filename).readlines
    output = Hash.new
    line_array.each_with_index do |text, line_number|
      if line_number % 3 == 1
        output[text.chomp] = line_array[line_number-1].chomp
      end 
    end
    output
  end


def build_deck(input_hash)
  deck = []
  input_hash.each_pair do |term, definition|
    deck << Card.new(term, definition)
  end
  deck
end
end

def parse_text(filename)
  parsed_file = read_file(filename)
    build_deck(parsed_file)
end
