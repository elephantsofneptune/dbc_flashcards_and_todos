class TodoParser
  def self.each_entry(path)
    File.open(path, "r").each_line do |line|
      yield parse_line(line)
    end
  end

  private
  def self.parse_line(line)
    match  = line.chomp.match(/^(?<id>\d+)\.\s
                                (?<status>.{3})\s+
                                (?<created_at>\[.{19}\] )?
                                (?<tags>\[.*\] )?+(?<task>.+)$/x)
    names  = match.names.map(&:to_sym)
    Hash[names.zip(match.captures)]
  end
end