# Will refactor later! 

require 'csv'
require 'english'

class Task
  attr_reader :text, :row_number
  attr_accessor :complete

  def initialize(row_number, text)
    @text = text[0]
    @row_number = row_number
    @complete = text[1] || "" # Thanks, Robby! :) 
  end

  def to_s
    "#{row_number}. #{text} [#{complete}]"
  end
end

class ToDo
  attr_accessor :list, :file, :add

  def initialize(file)
    @file = file
    @list = []
    @current_num_of_tasks = @list.length
    load!
  end

  def load!
    CSV.foreach(file) do |task|
      @list << Task.new($INPUT_LINE_NUMBER, task)
    end 
  end


  def list
    @list.map {|task| task.to_s}.join("\n")
  end

  def add(task)
    new_task = task.join(' ').split(',')
    @list << Task.new(@current_num_of_tasks + 1, new_task)
    puts "Appended \"#{new_task.join}\" to your TODO list"
    save!
  end

  def delete(task_number)
    @list.delete_if {|task| task.row_number.to_s == task_number}
    puts "Deleted #{task_number} from your TODO list" 
    save!
  end

  def save!
    CSV.open(file, "wb") do |csv|
      @list.each do |task|
        csv << [task.text,task.complete]
      end
    end
  end

  def complete(task_number)
    @list.each do |task|
      if task.row_number.to_s == task_number
        task.complete = "X"
        puts "Awesome. Marked #{task_number} as complete. Good job!"
      end
    end
    save!
  end
end

## Driver Code

if $ARGV.any?
  todo = ToDo.new('todo.csv')

  if $ARGV[0] == "list"
    puts todo.list
  elsif $ARGV[0] == "add"
    todo.add($ARGV[1..-1])
  elsif $ARGV[0] == "delete"
    todo.delete($ARGV[1])
  elsif $ARGV[0] == "complete"
    todo.complete($ARGV[1])
  end
end