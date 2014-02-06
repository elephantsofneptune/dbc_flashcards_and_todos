require 'csv'

class List
  attr_reader :list

  def initialize
    @list = Hash.new
  end
  def get_all_tasks
    puts "Here's what you need to do:"
    @list.each do |key, task|
      puts "#{key}. #{task.task}"
    end
  end
  def add_task(task_to_add)
    @list[@list.length] = Tasks.new({:task => task_to_add.join(" ")})
    post_edit
  end
  def delete_task(task_id)
    @list.delete(task_id.to_i)
    post_edit
  end
  def task_completed(task_id)
    @list[(task_id.to_i)].complete = true
    post_edit
  end
  def csv_parse
    CSV.foreach("todo.csv", {:headers => true, :quote_char => "|", :header_converters => :symbol}) do |row|
      @list[@list.length] = Tasks.new({:task => row[0], :complete => row[1]})
    end
  end
  def csv_save
    CSV.open('todo.csv', 'w+', :quote_char => "|") do |csv|
      csv << Tasks::ATTRIBUTES
      @list.each do |task_to_add|
        csv <<  [task_to_add[1].task, task_to_add[1].complete]
      end
    end
  end
  def post_edit
    puts "Your task has been added" if ARGV[0] == "add"
    puts "Task #{ARGV[1]} has been deleted" if ARGV[0] == "delete"
    puts "Task #{ARGV[1]} has been marked as complete" if ARGV[0] == "complete"
    csv_save
    get_all_tasks
  end
end

class Tasks
  ATTRIBUTES = %w{ task status }
  attr_reader :task
  attr_accessor :complete
  def initialize(args)
    @task     = args[:task]
    @complete = args[:complete] || false
  end
end

########### DRIVER CODE ###############
list = List.new
list.csv_parse

if ARGV[0] == "add"
  list.add_task(ARGV[1..-1])
elsif ARGV[0] == "delete"
  list.delete_task(ARGV[1])
elsif ARGV[0] == "complete"
  list.task_completed(ARGV[1])
else
  list.get_all_tasks
end