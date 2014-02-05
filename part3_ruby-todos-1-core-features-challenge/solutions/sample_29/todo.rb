# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller) command parser
# 2. Displaying information to the user (view) output
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

require 'csv'

class List
  def initialize(task_array)
    @task_list = []
    task_array.each_with_index { |task_csv_object, index|
    @task_list[index] = Task.new(task_csv_object) }
  end

  def add_task(task_string)
    @task_list << Task.new(task_string)
  end

  def delete_task(task_id)
    @task_list.delete_at(task_id)
  end

  def print_list
    print_string = ""
    @task_list.each_with_index { |task, index| print_string << "#{index+1}: #{task}\n" }
    print_string
  end

  def to_s
    print_list
  end

  def complete_task(task_id)
    @task_list[task_id].set_complete
  end

  def to_csv
    csv_array = []
    @task_list.each { |task| csv_array << task.to_csv_string  }
    csv_array
  end
end

class Task
  def initialize(task_csv_object)
    @task_hash = {}
    if task_csv_object.is_a? String
      @task_hash[:description] = task_csv_object
      @task_hash[:completed] = false
    elsif task_csv_object.is_a? CSV::Row
      @task_hash[:description] = task_csv_object[:description]
      @task_hash[:completed] = task_csv_object[:completed]
    end
  end

  def set_complete
    @task_hash[:completed] = true
  end

  def set_incomplete
    @task_hash[:completed] = false
  end

  def to_s
    "#{@task_hash[:description]} [#{@task_hash[:completed] == true ? "X" : " "}]"
  end
  
  def to_csv_string
    csv_array = []
    @task_hash.each {|key,value| csv_array << value }
    csv_array
  end
end


class FileHandler
  def initialize(file_location)
    @file_location = file_location
    @headers = []
  end

  def parse
    task_array = []
    @headers = CSV.open(@file_location,'r').shift

    CSV.foreach(@file_location, :headers => true, :header_converters => :symbol) do |row|      
      task_array << row
    end

    task_array
  end

  def save(list)
    CSV.open(@file_location, 'w') do |csv| 
      csv << @headers
      (list.to_csv).each { |task_array| csv << task_array}
    end
  end
end


def interpret_command(command_array, list)
  case command_array[0]
  when "add"
    new_task_string = command_array[(1..command_array.length-1)].join(" ")
    p new_task_string
    list.add_task(new_task_string)
  when "list"
    puts list.print_list
  when "delete"
    list.delete_task((command_array[1].to_i)-1)
  when "complete"
    list.complete_task((command_array[1].to_i)-1)

  end
end


parser = FileHandler.new('todo.csv')
task_list = List.new(parser.parse)
command = ARGV
interpret_command(command, task_list)
puts task_list.print_list
parser.save(task_list)
