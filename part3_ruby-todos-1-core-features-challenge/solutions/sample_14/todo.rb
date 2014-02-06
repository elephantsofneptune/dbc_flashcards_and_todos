# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# ruby todo.rb command0 command1
# showlist, add, delete, complete  are all possible ARGV[0]
# add+task_name, delete+num, complete+task_name
class List
  attr_accessor :tasks, :filename
  def initialize(filename)
    @filename = filename
    @tasks = []
    load
  end

  def load
    File.open(@filename).each do |line|
      @tasks << line
    end
  end

  def add(task_name)
    @tasks << Task.new(task_name)
    File.open(@filename, 'a') do |file|
      file << "#{task_name}\n"
    end
  end

  def delete_list!
    File.truncate(@filename, 0)
  end

  def update
    @tasks.each do |task_name|
      File.open(@filename, 'a') do |file|
        file << "#{task_name}"
      end
    end
  end

  def delete!(line_num)
    @tasks.delete_at(line_num-1)
  end
end

class Task
  attr_accessor :task_name, :completed
  def initialize(task_name)
    @task_name = task_name
    @completed = false
  end

  def complete!(line_num)
    @completed = true
  end
end

# DRIVE CODE
list1 = List.new('todo.csv')
command = ARGV[0]
ARGV.shift
arg = ARGV.join(" ")

case command
  when "showlist"
    line_num=0
    list1.tasks.each_with_index do |task, idx|
      print "#{idx + 1} #{task}"
    end
  when "add"
    list1.add(arg)
  when "delete"
    list1.delete!(arg.to_i)
    list1.delete_list!
    list1.update
  # when "complete"
  #   puts list1.tasks[arg.to_i]
end
