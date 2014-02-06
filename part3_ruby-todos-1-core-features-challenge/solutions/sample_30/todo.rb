# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).
require 'csv'

class Task
  attr_accessor :todo
  def initialize(args)
    @todo=args
  end
end

class List

  def initialize
    @todo_list = [] 
    @input = ''
  end

  def create_list
    CSV.foreach("todo.csv") do |rows|
      @todo_list << Task.new(*rows)
    end
    @todo_list
  end
  
  def display  
      @todo_list.each do |task|
      p task.todo  
  end

  end
  def add_task(arguments) 
    # p "inside of add_task-- " + arguments
    @todo_list << Task.new(arguments)

     CSV.open("todo.csv", "w") do |csv|
      @todo_list.each do |task|
        csv << [task.todo]
      end
    end
  end

  def delete_task(arguments)
    @todo_list.delete_at(arguments.to_i-1)
    CSV.open("todo.csv", "w") do |csv|
      @todo_list.each do |task|
        csv << [task.todo]
      end
    end
  end

end

def main(command, arguments)
  # p "beginning of main";
  # p arguments;
  list = List.new
  list.create_list
  if command == 'add'
    list.add_task(arguments.join(' '))  
  elsif command == 'delete'
    list.delete_task(arguments[0])
  else
    puts "add, delete(task number), display, mark_complete"
  end  
end

main(ARGV[0], ARGV[1..-1])