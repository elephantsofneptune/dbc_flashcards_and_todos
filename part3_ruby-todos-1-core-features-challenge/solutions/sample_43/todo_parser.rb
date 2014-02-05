#
# Example:
# TodoParser.each_entry('todo.txt') do |entry|
#   puts entry.inspect
# end

# Simple class for reading from the TODO file. Does not support writing.
class TodoParser
  def self.each_entry(path)
    File.open(path, "r").each_line do |line|
      yield parse_line(line)
    end
  end

  private
  def self.parse_line(line)
    # You can read this regular
    match = line.chomp.match(/^(?<id>\d+)\.\s+(?<description>.+)$/)
    # Lines for v1 of the file look like: <id>. <description>
    # The parentheses capture just those bits of the text.
    # These are called "capturing groups." The ?<id> syntax
    # gives those capturing groups names. Normally capturing
    # groups are referenced by position, e.g., "the first group"


    Hash[match.names.zip(match.captures)]
    # match.names returns ['id', 'description']
    # match.captures returns the values for those capturing groups
    #
    # match.names.zip(match.captures) becomes, e.g.,
    #   [['id', '1'], ['description', 'yadda yadda do this']]
    #
    # Hash[match.names.zip(match.captures)] becomes, e.g.,
    #   {'id' => '1', 'description' => 'yadda yadda do this'}
  end
end
