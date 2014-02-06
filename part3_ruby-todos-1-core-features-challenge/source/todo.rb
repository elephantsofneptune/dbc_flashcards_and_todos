# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# Task = Struct.new(:name, :completed) do
#   def complete
#     self.completed = true
#   end
# end

# class List
#   attr_reader :last_deleted

#   def initialize
#     @tasks=[Task.new("test1", false), Task.new("test2", false)] # test line, remove test objects!
#     @last_deleted = ''
#   end

#   def addTask(task)
#     @tasks << Task.new(task, false)
#   end

#   def deleteTask(index)
#     @last_deleted = @tasks[index][:name]
#     @tasks.delete_at(index)
#   end

#   def tasks
#     @tasks.map { |task| task.name }
#   end

# end

class UI
  require 'fileutils'

  def initialize(file="todo.txt")
    # @list = List.new
    @file = file
  end

  #Controller
  def parse 
    command = ARGV[0].to_sym
    arguments = ARGV[1..-1].join(' ')

    case command
    when :list
      view_list
    when :add
      addTask(arguments)
      taskAdded(arguments)
    when :delete
      deleteTask(arguments)
      taskDeleted(arguments)
      #@list.deleteTask(arguments.to_i - 1)
      # puts "Deleted \"#{@list.last_deleted}\" from your TODO list." 
    end
  end

  def addTask(task)
    File.open(@file, 'a') { |f| f.puts("#{task}" ) }
  end

  # def deleteTask(task)
  #   File.open(@file, 'w+') do |f|
  #     f.each_with_index do |line, index|
  #       f.puts "#{index+1}. #{line}" unless index+1 == task
  #     end
  #   end
  # end

  def deleteTask(taskIndex)
    FileUtils.touch("temp.txt")
    output = File.new("temp.txt")
    File.open(@file, 'w+').each_with_index do |task, index|
      output.puts "#{index}. #{task}" #unless index == taskIndex
    end
    FileUtils.cp(@file, "#{@file}.bk")
    FileUtils.mv("temp.txt", "todo.txt")
  end

  #VIEW
  
  def taskAdded(task)
    puts "Appended \"#{task}\" to your TODO list."
  end

  def taskDeleted(task)
    puts "Deleted \"#{task}\" from your TODO list." 
  end

  def view_list
    File.open(@file).each_with_index do |task, index|
      puts "#{index + 1}. #{task}"
    end
  end

end




# DRIVER CODE
# ruby todo.rb add Bake a delicious blueberry-glazed cheesecake
# $ ruby todo.rb list
# $ ruby todo.rb delete <task_id>
# $ ruby todo.rb complete <task_id>
# list = List.new("People to kill")
# list.addTask("Prime Minister")
# list.addTask("Paulie Shore")
# list.addTask("Freddie Mercury")
# list.deleteTask("Freddie Mercury")
# list.complete("Prime Minister")
# puts list.tasks
list = UI.new
list.parse