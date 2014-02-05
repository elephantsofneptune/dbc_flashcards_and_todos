# What classes do you need?
# List class -- individual list objects hold tasks
# Task class -- individual task objects hold titles, completeness status

# Remember, there are four high-level responsibilities, 
# each of which have multiple sub-responsibilities:

# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.csv file (model)
#    -- we need to be able to change the csv file...
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

require 'csv'

class Task
  @@running_total = 0  
  attr_reader :title, :status, :id
  
  def initialize(title)
    @id = @@running_total += 1
    @title = title
    @status = ' '
  end
  
  def complete_task!
    @status = 'X'
  end
end

class List
  attr_reader :name, :tasks
  
  def initialize
    @tasks = []
  end

  def add(task_obj)
    @tasks << task_obj 
  end

  def delete(task_id)
    @tasks.delete_if { |task_obj| task_obj.id == task_id.to_i }
  end

  def sort_by_status!
    @tasks.sort! { |task_obj_a, task_obj_b| task_obj_b.status <=> task_obj_a.status }
  end

  def number_of_incomplete_tasks
    @tasks.count { |task_obj| task_obj.status == ' ' }
  end
end

work_list = List.new
# declare list variable from csv file here...

CSV.foreach('todo.csv') do |csv|
  work_list.add(Task.new(csv[0]))
end

class View
  def self.render(list)
    puts "id\tstatus\t\ttitle"
    puts "--\t------\t\t-----"
    list.tasks.each do |task| 
      puts "#%3s\t[ %-1s ]\t%s" % [task.id, task.status, task.title]
    end
    puts "-"*50
  end
end

class Controller
  def self.start(command, value = nil, list)
    case command
    when "delete"
      puts "Deleted #{list.tasks[value.to_i - 1].title} from your list..."
      list.delete(value.to_i)
    when "add"
      list.add(Task.new(value))
      puts "Added #{list.tasks.last.title} to your list..."
      View.render(list)
    when "show"
      View.render(list)
    when "sort"
      list.sort_by_status!
      View.render(list)
    when "complete"
      list.tasks[value.to_i - 1].complete_task!
      View.render(list)
    else
      puts "Please enter show, add <task>, or delete <id>"
    end
    
    # # we want to write each task title as a new row in the csv file.
    CSV.open('todo.csv', 'wb') do |csv|
      list.tasks.map {|task| task.title}.each do |task_title|
        csv << [task_title]
      end
    end  
  end  
end


command = ARGV[0]
value = ARGV[1]

Controller.start(command, value, work_list)
