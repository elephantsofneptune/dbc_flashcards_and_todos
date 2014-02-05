require 'CSV'

class List

  def initialize
    @tasks = []
  end

  def addTask(task)
    @tasks << task
  end

  def getTasks
    @tasks
  end

  def deleteTask(task)
    @tasks.delete(task)
  end

  def completeTask(task)
    task.complete = true
  end

end #List

class Task
  attr_accessor :complete, :text

  def initialize(text, complete = false)
    @complete = complete
    @text = text
  end

end

class Interface

  def initialize
    @file = ('to_do_list.csv')
    @list = List.new()
  end

  def parseCommands
    @command = ARGV[0]
    parseFile
    if @command == "add"
      task = Task.new(ARGV[1..-1].join(' '))
      @list.addTask(task)
    elsif @command == "list"
      printList
    elsif @command == "delete"
      task = @list.getTasks[(ARGV[1].to_i) - 1]
      @list.deleteTask(task)
    elsif @command == "complete"
      task = @list.getTasks[(ARGV[1].to_i) - 1]
      @list.completeTask(task)
    elsif @command == "export"
      @name = ARGV[1]
      exportFile(@name)
    end  
    respondToCommand(task)
    saveFile
  end

  def printList
    @list.getTasks.each_with_index do |task, index|
      puts "#{index+1}. #{task.text}" + (task.complete ? " (complete)" : "")
    end
  end

  def respondToCommand(task)
    if @command == "add"  
      puts "Appended \"#{task.text}\" to your TODO list..."
    elsif @command == "delete"
      puts "Deleted \"#{task.text}\" from your TODO list..."
    elsif @command == "complete"
      puts "Updated \"#{task.text}\" to completed on your TODO list..."
    elsif @command == "export"
      puts "Exported your TODO list as \"#{@name}.txt\"..."
    end
  end

  def saveFile
    CSV.open(@file, 'w') do |line|
      @list.getTasks.each do |task_item|
        line << [task_item.text,task_item.complete]
      end
    end
  end

  def parseFile
    CSV.foreach(@file) do |line| 
      @list.addTask(Task.new(line[0], (line[1] == "true" ? true : false)))
    end
  end

  def exportFile(name)
    File.open(name + ".txt", "w") do |line|
      @list.getTasks.each_with_index do |task, index|
        line << "#{index+1}. [#{task.complete ? "x" : " "}]  #{task.text}\n"
      end
    end
  end

end #Interface

myInterface = Interface.new()
myInterface.parseCommands