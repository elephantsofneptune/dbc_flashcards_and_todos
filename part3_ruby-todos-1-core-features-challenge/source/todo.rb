class UI
  require 'fileutils'

  def initialize(file="todo.txt")
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
list = UI.new
list.parse