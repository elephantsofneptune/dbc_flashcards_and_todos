require 'csv'
require 'debugger'

class Task
  attr_accessor :description, :complete, :created_at, :completed_at, :tags

  def initialize(args)
    @complete = args.fetch(:complete){false}
    @description = args[:description]
    @created_at = args.fetch(:created_at){Time.now}
    @completed_at = args[:completed_at]
    @tags = args[:tags]
  end

  def to_array
    [@complete, @description, @created_at, @completed_at, @tags]
  end

  def complete!
    @complete = true
    @completed_at = Time.now
  end

  def complete?
    @complete
  end
end

class List
  attr_reader :file, :tasks

  def initialize(filename)
    @file = filename
    @tasks = load_tasks(@file)
    self.save
  end

  def load_tasks(file)
    tasks = []
    CSV.foreach(file) do |csv|
      if csv.size > 1
        tasks << Task.new({complete: csv[0], description: csv[1], created_at: csv[2],
                           completed_at: csv[3], tags: csv[4]})
      else
        tasks << Task.new({description: csv[0]})
      end
    end
    tasks
  end

  def match(task_num)
    @tasks[task_num - 1]
  end

  def add(task)
    @tasks << Task.new({description: task, complete: false})
    self.save
  end

  def delete(task)
    @tasks.delete(task)
    self.save
  end

  def complete(task)
    incomplete_task = @tasks.find { |t| t == task }
    incomplete_task.complete!
    self.save
  end

  def completed_tasks
    @tasks.select { |task| task.complete? == 'true' }
  end

  def outstanding_tasks
    @tasks.select { |task| task.complete? == 'false' }
  end

  def tag(task, new_tags)
    task.tags = new_tags
    self.save
  end

  def save
    CSV.open(@file, "wb") do |csv|
      @tasks.each { |task| csv << task.to_array }
    end
  end
end

class Controller

  def initialize(list)
    @list = list
  end

  def list(tasks = @list.tasks)
    counter = 1
    tasks.each do |task|
      complete_marker = task.complete? == 'true' ? "x" : " "
      puts "#{counter}. [#{complete_marker}] #{task.description}"
      counter += 1
    end
  end

  def list_outstanding
    outstanding_tasks = @list.outstanding_tasks
    sorted_tasks = outstanding_tasks.sort { |a,b| b.created_at <=> a.created_at }
    list(sorted_tasks)
  end

  def list_completed
    completed_tasks = @list.completed_tasks
    sorted_tasks = completed_tasks.sort { |a,b| a.completed_at <=> b.completed_at }
    list(sorted_tasks)
  end

  def add(task)
    @list.add(task)
    puts "Appended \"#{task}\" to your task list..."
  end

  def delete(task_num)
    task = @list.match(task_num.to_i)
    @list.delete(task)
    puts "Deleted \"#{task.description}\" from your task list..."
  end

  def complete(task_num)
    task = @list.match(task_num.to_i)
    @list.complete(task)
    puts "Completed \"#{task.description}\"..."
  end

  def tag(task_num, *tags)
    task = @list.match(task_num.to_i)
    formatted_tags = tags.drop(2)
    @list.tag(task, formatted_tags)
    puts "Tagging task \"#{task.description}\" with tags: #{formatted_tags.join(', ')}"
  end

  def filter(tag)
  end

  def print
    file = File.new('list.txt', 'w')
    counter = 1
    @list.tasks.each do |task|
      complete_marker = task.complete? == 'true' ? "x" : " "
      file.write("#{counter}. [#{complete_marker}] #{task.description}\n")
      counter += 1
    end
  end
end

controller = Controller.new(List.new('todo.csv'))

if ARGV.any?
  controller.send(ARGV[0].to_sym,ARGV[1],*ARGV) if ARGV[0] == 'tag'
  controller.send(ARGV[0].to_sym,ARGV[1]) if ['add','delete','complete'].include?(ARGV[0])
  controller.send(ARGV[0].to_sym) if ['print','list','list_outstanding','list_completed'].include?(ARGV[0])
  puts "Not a valid command." if !controller.methods.include?(ARGV[0].to_sym)
else
  puts "Please enter an argument."
end

# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# classes
# Task class
# List Class
# Controller Class
# View Class

# Attributes
# List - 
  # @todos = []
# Task
  # @description = string
  # @complete? = boolean
# Controller
  # Takes user input... initialized ARGV
  # Passes input to the "right" place
  # Take output from models and pass to views
# Views
  # Outputs controller stuff
