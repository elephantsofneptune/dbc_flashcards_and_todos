# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

$filename = "todo.txt"
require_relative "todo_fileIO"

class ListControl

  private

  attr_accessor :command_line_args, :model, :view

  public

  def initialize(command_line_args)
    @command_line_args = command_line_args
  end

  def execute
    inititalize_model
    initialize_view
    command = command_line_args.shift.to_sym
    self.send(command, command_line_args)
    finish
  end

  def inititalize_model
    @model = ListModel.new($filename)
    model.read
  end

  def initialize_view
    @view = ListView.new
  end

  def finish
    model.write
  end

  def list(args)
    view.all_tasks(model.list)
  end

  def add(args)
    description = args.join(' ')
    added_task = model.list.add(Task.new(description, false))
    view.add_task_response(added_task.description)
  end

  def delete(args)
    task_num = args.first.to_i
    deleted_task = model.list.delete(task_num)
    view.delete_task_response(deleted_task.description)
  end

  def complete(args)
    task_num = args.first.to_i
    completed_task = model.list.complete(task_num)
    view.complete_task_response(completed_task.description)
  end

end

class ListModel

  # include CSVParser
  include TextParser

  private

  attr_reader :filename

  public

  attr_accessor :list

  def initialize(filename)
    @list = List.new
    @filename = filename
  end

  def read
    # read_csv
    read_text
  end

  def write
    # write_csv
    write_text
  end

end

class ListView

  def all_tasks(list)
    if list.tasks.length > 0
      list.tasks.each_with_index do |task, i|
        puts "#{i+1}. [#{task.complete ? "X" : " "}]  #{task.description}"
      end
    else
      puts "List is empty"
    end
  end

  def add_task_response(description)
    if description != nil
      puts "Appended '#{description}' to your TODO list..."
    else
      error
    end
  end

  def delete_task_response(description)
    if description != nil
      puts "Deleted '#{description}' from your TODO list..."
    else  
      error
    end
  end

  def complete_task_response(description)
    if description != nil
      puts "'#{description}' has been completed..."
    else
      error
    end
  end

  def error
    puts "Invalid command"
  end

end

class List

  private

  attr_writer :tasks

  public

  attr_reader :tasks

  def initialize
    @tasks = []
  end

  def add(task)
    tasks << task
    tasks.last
  end

  def delete(task_num)
    tasks.delete_at(task_num - 1)
  end

  def complete(task_num)
    tasks[task_num-1].complete = true
    tasks[task_num-1]
  end

end

class Task

  attr_reader :description
  attr_accessor :complete

  def initialize(description, complete)
    @description = description
    @complete = complete
  end

end

driver = ListControl.new(ARGV)
driver.execute