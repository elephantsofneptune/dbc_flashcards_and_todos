require 'CSV'

#refactored Task class to take hash as input
#this will allow me to refactor csv parser to create arrays of any object that takes hash as input
class Task
  attr_reader :description, :status

  def initialize (task_hash)
    @description = task_hash[:description]
    @status = task_hash[:status]
  end

  def complete
    @status = "complete"
  end

  def to_a
    [@description, @status]
  end
end


class List
  attr_accessor :task_list

  def initialize(task_list)
    @task_list = task_list
  end
   
  def add (task)
    @task_list << task
  end

  def delete (index)
    @task_list.delete_at(index-1)
  end

  def list
    string = "" #{}"#".ljust(3) + "Description".ljust(60) + "Status" + "\n"
    @task_list.each_with_index {|task, index| string += "#{(index + 1).to_s.ljust(3) }  #{task.description.ljust(60)} (#{task.status}) \n"}
    string
  end
end

#created CSV parser object to create array of objects
class CSVParser  
  
  def initialize(csv_file)
    @csv_file = csv_file 
    @csv_array = []
    @headers = []  
  end

  def make_object_array (object)
    @headers = CSV.open(@csv_file,"r").shift 
    CSV.foreach(@csv_file, {:header_converters => :symbol, :converters => :all, :headers => true}) do |row|
      row_hash = Hash[row.headers.zip(row.fields)]
      @csv_array << object.new(row_hash)
    end 
    @csv_array
  end

  def save (array)
    CSV.open(@csv_file, "w") do |csv|
      csv << @headers
      array.each {|row| csv << row }
    end
  end
end


module ProcessInput
  COMMAND = ARGV.shift
  INPUT_STRING = ARGV.join(" ")

  def self.commands (input_list)
    case (COMMAND)
    when "list"
      puts input_list.list
    when "add"
      input_list.add(Task.new(INPUT_STRING))
    when "delete"
      input_list.delete(INPUT_STRING.to_i)
    when "complete"
      task = input_list.task_list[INPUT_STRING.to_i-1]
      task.complete
    else
      puts "invalid entry to todo list app"
    end
  end
end


csv_parser = CSVParser.new('todo.csv')
tasks = csv_parser.make_object_array(Task)
my_list =  List.new(tasks)
ProcessInput::commands (my_list)
output_array = my_list.task_list.map{|task| task.to_a}
csv_parser.save(output_array)


