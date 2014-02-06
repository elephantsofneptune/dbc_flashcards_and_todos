# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# STDIN.gets

#Controller
  # Creates lists
  # Adds task to a list


#View
  # Display list
  # Reacts to user input


#Model
  # Stores TODO lists
  # Stores tasks


#Interface

Task = Struct.new(:name, :completed)
# List = Struct.new(:name, :tasks) do
#   :tasks = []
#   def addTask(task)
#     :tasks << Task.new(task, false)
#   end
#   def deleteTask(task)
#     :tasks.delete(task)
#   end
#   def complete(task)
#     p task#[:completed] #= true
#   end
# end

class List

  attr_reader

  def initialize(name)
    @name = name
    @tasks=[]
  end


  def addTask(task)
    @tasks << Task.new(task, false)
  end

  def deleteTask(task)
    @tasks.delete(task)
  end

  # def complete(task)
  #   p tasks.find(name)#[:completed]
  # end

  def tasks
    @tasks.map { |task| task.name }
  end
end




# DRIVER CODE
# ruby todo.rb add Bake a delicious blueberry-glazed cheesecake
# $ ruby todo.rb list
# $ ruby todo.rb delete <task_id>
# $ ruby todo.rb complete <task_id>
list = List.new("People to kill")
list.addTask("Prime Minister")
list.addTask("Paulie Shore")
list.addTask("Freddie Mercury")
list.deleteTask("Freddie Mercury")
list.complete("Prime Minister")
puts list.tasks
