module FileInterface
  def self.read(file)
    list_file = File.open(file, "r")
    lines = list_file.readlines
    list_file.close
    return lines
  end

  def self.write(array, file)
    list_file = File.open(file, "w")
    array.each {|task| list_file.puts task}
    list_file.close
  end
end

class List
  include FileInterface
  def initialize(file)
    @file = file
    @list_arry = FileInterface.read(@file)
  end
  
  def print
    return "No list items" if File.zero?(@file)
    @list_arry.each do |row|
      puts "#{@list_arry.index(row) + 1}. #{row}"
    end
  end

  def add(task)
    @list_arry << task
  end

  def delete(n)
    @list_arry.delete_at(n - 1)
  end

  def complete(n)
    @list_arry[n - 1] = @list_arry[n - 1].strip + " DONE"
  end
 
  def promote(old_n, new_n)
    item = @list_arry[old_n - 1]
    @list_arry.delete_at(old_n - 1)
    @list_arry.insert(new_n - 1, item)
  end

  def return_list
    FileInterface.write(@list_arry, @file)
  end

end

class ListManager
  def initialize
    puts "Please enter a file"
    @file = gets.chomp
    @list = List.new(@file)
    get_commands
  end

  def get_commands
    print "Enter a command or type help: "
    command = gets.chomp

    case command
    when "add"
      puts "Enter new task: "
      task = gets.chomp
      @list.add(task)
      @list.print 
    when "list"
      @list.print
    when "complete"
      puts "Enter the list number of completed task:"
      n = gets.chomp.to_i
      @list.complete(n)
    when "delete"
      puts "Enter the list number of task to delete: "
      n = gets.chomp.to_i
      @list.delete(n)
    when "help"
      puts "Available commands: add, list, complete, delete, quit, promote, help"
    when "quit"
      @list.return_list
      puts "Bye"
      exit
    when "promote"
      print "Enter number of task to promote: "
      old_n = gets.chomp.to_i
      print "Enter new number for task: "
      new_n = gets.chomp.to_i
      @list.promote(old_n, new_n)
    else
      puts "Command not found, enter another"
    end
    get_commands
  end
end

ListManager.new


# ___________________

# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

# > help
# > add (task)


# # commands
# add
# list
# delete
# complete
# quit
# help
