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
  attr_accessor :box, :id, :description, :date_added

  def initialize(box,id,description,date_added)
    @box = "[_]"
    @id = id.to_s
    @description = description
    @date_added = date_added
  end

  def print_task
   "#{@box}" + " " + "#{@id} " + "#{@description} " + "created on " + "#{@date_added}"
  end

  def complete
    gsub!(/[\[\_\]]/, "[X]")
  end

  def undo
    gsub!(/[\[\X\]]/, "[_]")
  end

  def to_s
    self.print_task
  end
end





class ToDoList
  attr_reader :file, :list

  def initialize(file)
    @file = file
    @list = []
    import_list
    system "clear"
    command_line
  end

  def import_list
    return @list unless @list.empty?
    task_num = 1
    CSV.foreach(@file) do |row|
      @list << Task.new("[_]", task_num, row[0], Time.now)
      task_num += 1 # incrementally adds one to the task number
    end
    @list
  end

  def add_task(description)
    last_task_id = @list.last.id
    @list << Task.new("[_]", last_task_id.to_i + 1, description, Time.now)
  end

  def export_list
  CSV.open(@file, "w") do |csv|
    @list.each {|task| csv << [task.box, task.id, task.description, task.date]}
    end
  end

  def print_list
    @list.map { |task| task.print_task }
  end

  def print_incomplete
    @list.select { |task| task if task.box == "[_]" }
  end

  def print_completed
    @list.select { |task| task if task.box == "[X]" }
  end

  def complete_task(id)
    @list.select { |task| task.complete if task.id == id}
  end

  def undo_task(id)
    @list.select { |task| task.undo if task.id == id}
  end

  def command_line
    puts   "\n\n"
    print  "-------------------------------------" 
    puts"\n""========  U GOT THANGS 2 DO  ========""\n" 
    puts   "-------------------------------------"
    puts   "          "
    puts   "all"
    puts   "completed"
    puts   "incomplete"
    puts   "add"
    puts   "check"
    puts   "uncheck"
    puts   "-------------------------------------"
    choice = gets.chomp
    while choice != "exit"
    while choice == "all"
    system "clear"
      puts self.print_list
      command_line
      end
    system "clear"
    while choice == "incomplete"
      puts self.print_incomplete
      command_line
      end
    system "clear"
    while choice == "completed"
      puts self.print_completed
      command_line
      end
    system "clear"
    while choice == "add"
      puts "type description of task"
      description = gets.chomp
      add_task(description)
      system "clear"
      puts self.print_list
      command_line
      end
    system "clear"
    while choice == "check"
      puts self.print_list
      puts "type the id of the task you finished"
      description = gets.chomp.to_s
      self.complete_task(description)
      system "clear"
      puts self.print_list
      command_line
      end
    system "clear"
    while choice == "uncheck"
      puts self.print_list
      puts "type the id of the task you want to uncheck"
      description = gets.chomp.to_s
      self.list.undo_task(description)
      system "clear"
      puts self.print_list
      command_line
      end
    system "clear"
    end
  end
end


rockyslist = ToDoList.new('todo.csv')



# if $ARGV.any?
#   if $ARGV[0] == "all"
#     puts rockyslist.print_list
#   elsif $ARGV[0] == "incomplete"
#     puts rockyslist.print_incomplete
#   elsif $ARGV[0] == "complete"
#     rockyslist.complete_task($ARGV[1])
#   elsif $ARGV[0] == "complete"
#     rockyslist.undo_task($ARGV[1])
#   end
# end
