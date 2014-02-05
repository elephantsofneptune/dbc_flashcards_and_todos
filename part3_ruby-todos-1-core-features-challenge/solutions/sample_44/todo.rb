require 'csv'

class List
  
  attr_reader :task_list

  def initialize(file)
    @file          = file
    @task_list     = []
  end
  
  def load_list
    CSV.foreach(@file, :quote_char => "|") do |task|
      @task_list << Task.new(task[0], task[1])
    end
  end
  
  def perform_task
    if ARGV[0]    == "list"
      print_tasks
    elsif ARGV[0] == "add"
      add_tasks
    elsif ARGV[0] == "delete"
      delete_tasks
    elsif ARGV[0] == "complete"
      complete_task
    end
    print_tasks
    save_todo_list
  end
  
  def add_tasks
    new_task = ARGV[(1..-1)].join(" ")
    @task_list << Task.new(new_task)
  end
  
  def complete_task
    @task_list[ARGV[1].to_i - 1].completed_task = %w(X)
  end

  def delete_tasks
    @task_list.delete_at(ARGV[1].to_i - 1)
  end

  def print_tasks
    @task_list.each_with_index do |task, index|
      print (index + 1).to_s + ". "
      print task.task_string
      puts task.completed_task
    end
  end
  
  def save_todo_list
    CSV.open("todo.csv", "wb", :quote_char => "|") do |csv|
      @task_list.each do |task|
        csv << [task.task_string, task.completed_task]
      end
    end
  end
end

class Task
  
  attr_reader :task_string
  attr_accessor  :completed_task

  def initialize(task_string, completed_task = " ")
    @task_string = task_string
    @completed_task = completed_task
  end

end

new_list = List.new('todo.csv')
new_list.load_list
new_list.perform_task
