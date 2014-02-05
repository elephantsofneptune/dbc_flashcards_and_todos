# Solution for Challenge: Ruby Todos 2.0: Additional Features. Started 2013-06-14T01:45:10+00:00

# Your order ( #373294764 ) for $66.84 on 6/15/2013 at 2:12 PM was sent to the kitchen at Original Buffalo Wings SF. Expect an email soon to confirm they're cooking up* your food. Prepare for food happiness!
# In the unlikely event that you should have any food or delivery-related issues with your order, please contact Original Buffalo Wings SF at (415) 931-8181

# Refactoring Notes

# The controller, View and model now interact with their contained objects correctly and with fewer lines of code.
# Each Model is reposbile for providing methods to the outside world, so we can manipulate the class objects.
# All jobs are correctly delegated to the right function. There is no unnecessary or badly placed puts statements to out the data.
#   All put statements are now in the View.

# Code is clean and functions are small.

# All tests have passed, and all messages are displayed corectly



require 'CSV'
require 'date'

class Task
  attr_accessor :thing_to_do,:complete,:created_at,:completed_at,:tags

  include Comparable

  def initialize(args)
    @thing_to_do = args[:thing_to_do]
    @tags = args[:tags] == nil ? [] : args[:tags].split
    @created_at  = args[:created_at] || DateTime.now
    @complete = args[:complete] || "[ ]"
    @completed_at = args[:completed_at] == nil ? nil : DateTime.parse(args[:completed_at])
  end

  def add_tags(tags_array)
    @tags+= tags_array
  end

  def mark_complete
    @complete, @completed_at = "[X]", DateTime.now
  end

  def tag_list
    @tags.join(' ')
  end
end

class TodoList
  attr_reader :tasks

  def initialize(args)
    @tasks = args[:tasks] || []
    self.read(args[:filename]) if args[:filename]
  end

  def add(thing_to_do)
    @tasks << Task.new(thing_to_do: thing_to_do)
  end

  def delete(index)
    task = @tasks.delete_at(index-1)
  end

  def mark_complete(index)
    @tasks[index-1].mark_complete
  end

  def tag(index,tags_array)
    @tasks[index-1].add_tags(tags_array)
    puts "Tagging task #{@tasks[index-1].thing_to_do} with #{tags_array.join(' ')}"
  end

  def save
    CSV.open('todo.csv', "wb") do |csv|
      csv << ['complete','thing_to_do','created_at','completed_at','tags']
      @tasks.each_with_index do |task,i|
        csv << [task.complete ,task.thing_to_do,task.created_at,task.completed_at,task.tag_list]
      end
    end
  end

  def read(filename)
    CSV.foreach(filename, :headers => true, :header_converters => :symbol) {|row| @tasks << Task.new(row)}
  end
end

module TodoView
  def print_list(tasks)
    tasks.each_with_index {|task,i| puts "#{i+1}.".rjust(3) + " #{task.complete}".ljust(3) + " #{task.thing_to_do} #{task.created_at} #{task.completed_at}"}
  end

  def print_add_message(thing_to_do)
    puts "\nAdded #{thing_to_do} to your TODO list\n"
  end

  def print_delete_message(index)
    puts "\nDeleted #{index} from your TODO list\n"
  end

  def print_complete_message(index)
    puts "\nCompleted #{index} from your TODO list\n"
  end

  def print_filtered_list(tasks,filter_string)
    tasks.each_with_index {|task,i| puts "#{i+1}.".rjust(3) + " #{task.complete}".ljust(3) + " #{task.thing_to_do} [#{filter_string}]"}
  end
end

class TodoListController
  attr_accessor :task_list

  include TodoView

  def initialize(filename)
    @task_list = TodoList.new(filename)
  end

  def list(arguments)
    print_list(@task_list.tasks)
  end

  def add(arguments)
    @task_list.add(arguments)
    print_add_message(arguments)
  end

  def delete(arguments)
    @task_list.delete(arguments.to_i)
    print_delete_message(arguments)
  end

  def complete(arguments)
    @task_list.mark_complete(arguments.to_i)
    print_complete_message(arguments)
  end

  def list_outstanding(arguments)
    print_list(@task_list.tasks.select {|task| task.complete == '[ ]'}.sort_by {|task| task.created_at}.reverse)
  end

  def list_completed(arguments)
    print_list(@task_list.tasks.select {|task| task.complete == '[X]'}.sort_by {|task| task.completed_at}.reverse)
  end

  def tag(arguments)
    @task_list.tag(arguments.split[0].to_i,arguments.split[1..-1])
  end

  def filter(filter_string)
    print_filtered_list(@task_list.tasks.select {|task| task.tags.include? filter_string},filter_string)
  end

  def save_list
    @task_list.save
  end

  def parse
    command, arguments = ARGV[0], ARGV[1..-1].join(' ') 
  end
end

controller = TodoListController.new(filename: "todo.csv")
command,arguments = controller.parse
command = command.sub(':','_')
arguments, command = command[7..-1], 'filter' if command.include? 'filter'
controller.send(command,arguments)
controller.save_list
