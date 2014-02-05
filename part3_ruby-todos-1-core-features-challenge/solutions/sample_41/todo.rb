require 'csv'

# Domain-Specific Model
class Task

  attr_reader :statement, :id
  attr_accessor :complete

  def initialize(id, statement, complete = 'false')
    @id = id
    @statement = statement
    @complete = complete
  end

  def to_s
    @complete == 'true' ? check = "X" : check = " "
    "#{@id}.".ljust(4) + "[#{check}] #{@statement}"
  end
end

# Model
class List

  attr_reader :tasks
  def initialize
    @tasks = []
  end

  def add(string, complete = 'false')
    task = Task.new(@tasks.length+1, string, complete)
    @tasks << task
  end

  def parse(filename)
    CSV.foreach(filename) { |csv| add(csv[0], csv[1]) }
  end

  def delete_by_id(id_number)
    @tasks.delete_if { |task| task.id == id_number }
  end

  def complete_by_id(id_number)
    @tasks.each { |task| task.complete = 'true' if task.id == id_number }
  end

  def print_to_csv(filename)
    CSV.open(filename, 'wb') do |csv| 
      @tasks.each { |task| csv << [task.statement, task.complete] }
    end
  end
end

# View
class View
  def self.get_selection(list)
    case ARGV[0]
    when 'add'
      string = ARGV[1..-1].join(' ')
      list.add(string)
    when 'list'
      self.print_tasks(list)
    when 'delete'
      list.delete_by_id(ARGV[1].to_i)
    when 'complete'
      list.complete_by_id(ARGV[1].to_i)
    else
      puts 'NOT VALID'
    end
  end

  def self.print_tasks(list)
    list.tasks.each { |task| puts task }
  end

  def self.print_to_file(list, filename)
    File.open(filename, 'w') do |file|
      list.tasks.each { |task| file.puts task }
    end
  end

end

#DRIVER CODE

#Controller
class Todo
  def self.start(csv_file, text_file)
    list = List.new
    list.parse(csv_file)
    View.get_selection(list)
    list.print_to_csv(csv_file)
    View.print_to_file(list, text_file)
  end
end

Todo.start('todo.csv', 'todo.txt')

