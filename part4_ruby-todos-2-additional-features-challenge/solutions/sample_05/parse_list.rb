require 'csv'
require './task'

class ParseList
  attr_reader :todo_list

  def initialize(file)
    @file = file
    @todo_list = []
    parse_csv
    sort_list!
  end

  def parse_csv
    CSV.foreach(@file, :headers => true, :header_converters => :symbol) do |row|
      @todo_list << Task.new(row)
    end
  end

  def save_csv
    CSV.open(@file, 'wb') do |row|
      row << ['task', 'status', 'priority', 'date', 'tag']
      @todo_list.each do |task|
        row << [task.task, task.status, task.priority, task.date, task.tag]
      end
    end
  end

  def sort_list!
    @todo_list = @todo_list.sort_by { |task| task.priority.to_i }
  end
end