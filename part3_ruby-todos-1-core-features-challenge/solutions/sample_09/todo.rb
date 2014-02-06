require 'csv'

class Task
  attr_reader :task_text
  def initialize(input)
    @task_text = input
  end

  def mark_done(task)

  end

  def to_a
    [self.task_text.pop]
  end
end

class List
  def initialize(file = nil)
    @file = file
    Parser.new(@file) if file != nil
  end

  def add(new_task)
    new_task = new_task.join(" ")
    task = Task.new(new_task)
    File.open(@file,"a") do |file|
      file.write(task.task_text)
    end
  end

  def delete(task_num)
  
  end

  def mark_done(task_num)

  end

  def display_tasks
  end

  def display_done
  end
end

class Parser
  attr_reader :list_name
  def initialize(csv_file)
    @file_name = csv_file
    @list = []
    self.create_list
  end

  def create_list
    CSV.foreach(@file_name) do |row|
      @list << Task.new(row)
    end
    self.save
  end

  def save
    Templater.new(@file_name, @list)
  end 
end

class Templater
  def initialize(file_name, list)
    @list = list
    @file_name = file_name
    self.save
  end 

  def save
    CSV.open(@file_name, "wb") do |file| 
      @list.map do |task_text|
      file << task_text.to_a
      end
    end
  end
end

class Controller
  attr_reader :input, :list, :command
  def initialize
    @input = ARGV
    self.find_list
  end

  def find_list
    @file_name = @input.shift
    self.determine_command
  end
  
  def determine_command
    @command = @input.shift
    self.perform_command
  end

  def perform_command   #need to still make work 
    case @command
    when "add" 
      @list = List.new(@file_name)
      @list.add(@input)
    when "delete"
    when "mark done"
    when "display_tasks"
    when "display_done"
    end
  end
end


controller = Controller.new
# p controller.command
# p controller.list
p 

__END__
# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

Two Ways to Create a list:
list = List.new                     # creates a new list
parser.create_list(csv_file)        # parsing the CSV into task objects

Ways to edit list:
list.add(Task.new("walk the dog"))  # adds a task to todo list
list.delete(task_num)               # delete a particular task 

Ways to edit tasks:
task = Task.new                     # create task
task.mark_done                      # mark a task complete

Viewing list:
list.display_tasks                  # displays all the tasks on a todo list (including completed, not including deleted)
list.display_done                   # display list of done tasks

UI:
controller.get_input                # take user input and call command

Tools for doing the other things:
parser = Parser.new                 # creates new parser
controller = Controller.new         # creates a controller
templater = templater.new           # creates new templater

templater.save(list)                # saves list to csv file