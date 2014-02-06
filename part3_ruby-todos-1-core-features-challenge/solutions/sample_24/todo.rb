# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).



require 'csv'

# read csv file
# split into array of things to do
# print out that formatted list

class CsvParser
  attr_reader :to_do_list

  # read the lines of a file
  def self.parse_csv(file_name)
    csv_lines = []
    CSV.foreach(file_name) { |row| csv_lines << row }
    csv_lines
  end

  # write to a CSV file, takes a file name and todo_list which is already formatted (an array of arrays)
  def self.save(file_name, todo_list)
    CSV.open(file_name, "w") do |csv|
      todo_list.each { |row| csv << row }
    end
  end
end

class Task
  attr_reader :id, :text
  attr_accessor :completed, :marked_done

  def initialize(args)
    @id = args.fetch(:id) { nil }
    @text = args[:text]
    @completed = args.fetch(:completed) { false }
    @marked_done = []
    if @completed == true
      @marked_done = "[X]"
    else
      @marked_done = "[ ]"
    end
  end
end

class ToDoList
  attr_reader :to_do_list

  def initialize(parsed_csv)
    @to_do_list = make_array_of_tasks(parsed_csv)
  end

  def make_array_of_tasks(parsed_csv)
    task_array = []
    parsed_csv.each_with_index { |row, i| task_array << Task.new(text: row[0], id: i+1, completed: (row.last.strip == "true")) }
    task_array
  end

  # task list is a ToDoList object, @to_do_list is it's array that we want
  def format_task_list #(curr_todolist_obj)
    csv_ready_list = []
    self.to_do_list.each { |task| csv_ready_list << [task.text, task.completed] }
    csv_ready_list
  end

  def add(task_text)
    id = @to_do_list.length + 1
    @to_do_list << Task.new(text: task_text, id: id)
  end

  def delete(task_idx)
    id = task_idx.to_i - 1
    @to_do_list.delete_at(id)
  end

  def complete(task_idx)
    @to_do_list[task_idx.to_i - 1].marked_done = "[X]"
    @to_do_list[task_idx.to_i - 1].completed = true
  end

end
 

# DRIVER CODE
csv_todo_list = CsvParser.parse_csv('todo.csv') #returns rows of the csv file
this_list = ToDoList.new(csv_todo_list)

command = ARGV

case command[0]
  when "list"
    # print out a numbered todo list
    this_list.to_do_list.each do |task|
      puts "#{task.id}. #{task.marked_done} #{task.text}."
    end
  when "add"
    # check what command[1] is and add a new task to the list with the string in command[1]
    # as the @text
    text = command.drop(1).join(" ")    
    this_list.add(text)
    csv_ready_list = this_list.format_task_list
    CsvParser.save('todo.csv', csv_ready_list)
    puts "Appended #{text} to your TODO list.."
  when "delete"
    # check what command[1] is and remove the task whose @text == command[1]
    task_idx = command[1]
    deleted = this_list.delete(task_idx)
    puts "Deleted '#{deleted.text}' from your TODO list..."
    csv_ready_list = this_list.format_task_list
    CsvParser.save('todo.csv', csv_ready_list)
  when "complete"
    # check what command[1] is and set @completed to true for the task whose @text == command[1]
    task_idx = command[1]
    this_list.complete(task_idx)
    csv_ready_list = this_list.format_task_list
    CsvParser.save('todo.csv', csv_ready_list)
end


