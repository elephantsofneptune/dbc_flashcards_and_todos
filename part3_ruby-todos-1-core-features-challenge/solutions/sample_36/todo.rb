require 'csv'

# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

class List
  attr_accessor :current_tasks, :completed_tasks

  def initialize(input)
    completed = []
    index_completed = input.find_index(["Completed Tasks"]) || input.length
    current = input[0..(index_completed - 1)]
    completed = input[(index_completed + 1)..-1] if index_completed != input.length
    @current_tasks = current.map { |task| Task.new(task) unless task == ["Completed Tasks"]}
    @completed_tasks = completed.map { |task| Task.new(task) }
  end

  def pass_command(action, user_task)
  
    user_task[0] = user_task[0].upcase if user_task.length > 0
    case action
    when "add"
      add_task(user_task) unless user_task == ""
    when "delete"
      delete_task(user_task) unless user_task == ""
    when "complete"
      complete_task(user_task) unless user_task == ""
    when "list"
      show_tasks("all")
    when "current"
      show_tasks("current")
    when "completed"
      show_tasks("completed")
    else
      puts "Please choose from add, delete, complete, list, current, or completed."
      puts "Commands add, delete and complete require a specific task."
      puts
    end
  end

  def add_task(user_task)
    @current_tasks.push(Task.new([user_task]))
    puts "We added \"#{user_task}\" to your list. Go slay that dragon!"
  end

  def delete_task(user_task)
    task_to_be_deleted = ObjectSpace.each_object.select { |obj| obj.class == Task && obj.task == [user_task]}
    @current_tasks -= task_to_be_deleted
    @completed_tasks -= task_to_be_deleted
    puts "We deleted \"#{user_task}\" from your ToDo list. Rock n Roll!"
  end

  def complete_task(user_task)
    task_to_be_completed = ObjectSpace.each_object.select { |obj| obj.class == Task && obj.task == [user_task]}
    @current_tasks -= task_to_be_completed
    @completed_tasks += task_to_be_completed
    puts "You just completed \"#{user_task}\" like a champ! The Hoff would be proud!"
  end

  def show_tasks(subset)
    case subset
    when "all"
      show_all_tasks
    when "current"
      show_current_tasks
    when "completed"
      show_completed_tasks
    end
  end

  def show_all_tasks
    show_current_tasks
    show_completed_tasks
  end

  def show_current_tasks
    puts "All Current Tasks"
    current_tasks.to_enum.with_index(1) { |task, index| puts "#{index}. #{task.task[0]}" }
    puts
  end
  
  def show_completed_tasks
    if completed_tasks.length > 0
      puts "All Completed Tasks"
      completed_tasks.to_enum.with_index(1) { |task, index| puts "#{index}. #{task.task[0]}" }
      puts
    end
  end

end

class Task
  attr_accessor :task

  def initialize(user_task)
    @task = user_task
  end
  
  def to_s
    task
  end

end


class Controller
  attr_accessor :input, :list

  def initialize
    @input = []
  end

  def run
    ensure_ARGV

    load_list
    @list = List.new(input)
    action, user_task = parse_ARGV
    list.pass_command(action, user_task)
    
    rebuild_csv
    save_list
  end


  def ensure_ARGV
    if ARGV == []
      puts "The list needs your input!"
      puts
      exit
    end
  end

  def parse_ARGV
    action = ARGV[0]
    user_task = ARGV[1..-1].join(" ")
    return action, user_task
  end

  def load_list
    CSV.foreach('todo.csv') do |row| #ability to read or write from the file
      self.input << row
    end
  end

  def rebuild_csv
    @input = []
    list.current_tasks.each do |task|
      @input << task.to_s
    end
    @input << ["Completed Tasks"]
    list.completed_tasks.each do |task|
      @input << task.to_s
    end
  end

  def save_list
    CSV.open('todo.csv', 'wb') do |csv|
      input.each do |input_line|
        csv << input_line
      end
    end
  end

end




controller = Controller.new

controller.run
