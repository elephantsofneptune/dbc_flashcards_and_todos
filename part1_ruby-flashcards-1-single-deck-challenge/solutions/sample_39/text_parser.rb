class TextParser

  #i: instance variable @file
  def self.read_file(file)
    File.open(file).readlines
  end
  #o: array of strings

  #i: array of strings
  def self.arrays_to_hashes(array_of_strings)
    output = []
    sliced_cards = array_of_strings.each_slice(3).to_a
    sliced_cards.each do |definition, answer|
      output << {:definition => definition.chomp, :answer => answer.chomp}
    end
    output
  end
  #o: array of hashes

  # call load and arrays_to_hashes, return array of hashes
  def self.run(file)
    arrays_to_hashes(read_file(file))
  end
end