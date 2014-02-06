require 'csv'


module FlashCardDatabase
  module CSVFormat
    def self.save_to(args)
      CSV.open("#{args[:file]}.csv", "w") do |csv|
        csv << ["definition", "term"]
        args[:cards].each do |card|
          csv << [card.definition, card.term]
        end
      end
    end

    def self.parse_to(args)
      arr = []
      p args[:file]
      CSV.foreach("#{args[:file]}.csv") do |row|
        unless row[0] == "definition"
          arr << {definition: row[0], term: row[1]}
        end
      end
      return arr
    end
  end

  module HumanReadableFormat
    def self.save

    end

    def self.parse

    end
  end
end
