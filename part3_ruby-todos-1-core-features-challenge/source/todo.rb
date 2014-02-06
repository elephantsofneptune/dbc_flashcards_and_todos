# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

Task = Struct.new(:name, :completed) do
  def complete
    self.completed = true
  end
end

class List
  attr_reader :last_deleted

  def initialize
    @tasks=[Task.new("test1", false), Task.new("test2", false)] # test line, remove test objects!
    @last_deleted = ''
  end

  def addTask(task)
    @tasks << Task.new(task, false)
  end

  def deleteTask(index)
    @last_deleted = @tasks[index][:name]
    @tasks.delete_at(index)
  end

  def tasks
    @tasks.map { |task| task.name }
  end

end

class UI

  def initialize
    @list = List.new
  end

  def parse
    command = ARGV[0].to_sym
    arguments = ARGV[1..-1].join(' ')

    case command
    when :list
      @list.tasks.each_with_index do |task, index|
        puts "#{index + 1}. #{task}"
      end
    when :add
      @list.addTask(arguments)
      puts "Appended \"#{arguments}\" to your TODO list."
    when :delete
      @list.deleteTask(arguments.to_i - 1)
      puts "Deleted \"#{@list.last_deleted}\" from your TODO list." # Calling a method from list here = Troubles!
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