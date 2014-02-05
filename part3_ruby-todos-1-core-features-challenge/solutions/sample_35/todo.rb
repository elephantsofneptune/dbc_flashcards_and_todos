################################################################################
# Ruby Todos 1.0: Core Features
# Partner: none
# Date: 2013-04-11
################################################################################

require 'csv'
require 'date'
require 'forwardable'

require 'rspec' # debugging
require 'pry' # debugging

################################################################################
# TBD
################################################################################

  # poorly-formatted text import (note: not export)
  # File permanence & Load

################################################################################
# CLASSES
################################################################################





class String
  def to_bool
    return true   if self == 'true'  || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == 'false' || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end








class TodoTask
  
  attr_accessor :completed, :due_date, :description, :creation_date, :id
  
  def initialize(args)
    @completed = args[:completed] ? args[:completed].to_bool : false
    @due_date = args[:due_date] || nil
    @description = args[:description]
    @creation_date = args[:creation_date] || DateTime.new
    @id = args[:id].to_i
  end

end








class TodoModel

  attr_reader :task_controller
  attr_accessor :tasks

  def initialize(task_controller_s)
    @task_controller = task_controller_s
    @tasks = []
  end

  def add(descrip)
    self.tasks << TodoTask.new({ description: descrip,
                                 id: (self.tasks.length + 1)})
    self.reset_ids
  end

  def reset_ids
    i = 1
    self.tasks.each do |task|
      task.id = i
      i += 1
    end
  end

  def save_to_csv!(file)
    CSV.open(file, "wb", :headers => true) do |csv|
      csv << ["id", "Creation Date", "Due Date", "Description", "Completed"]
      self.tasks.each do |task|
        csv << [task.id.to_s, task.creation_date.to_s, task.due_date.to_s, task.description.to_s, task.completed.to_s]
        # puts "#{task.id.to_s}, #{task.creation_date.to_s}, #{task.due_date.to_s}, #{task.description.to_s}, #{task.completed.to_s}"
      end
    end
  end

  def complete_id(id)
    self.tasks.each do |task|
      task.completed = true if task.id == id
    end
  end
  
  def delete_id(num)
    self.tasks.delete_if {|task| task.id == num }
    reset_ids
  end

  def load(file) # refactor fodder: move reset_ids into this
    return load_from_csv(file) if file.include?('.csv')
    return load_from_txt(file) if file.include?('.txt')
    raise "Don't know how to load that yet"
  end

  def load_from_csv(csv_file)
    CSV.foreach(csv_file, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      self.tasks << TodoTask.new(Hash[row.headers[0..-1].zip(row.fields[0..-1])])
    end
    self.reset_ids
  end

  def load_from_txt(txt_file)
    File.open(txt_file).each do |line_of_txt|
      self.tasks << TodoTask.new({description: self.txt_str_to_task_obj(line_of_txt)})
    end
    self.reset_ids
  end

  def txt_str_to_task_obj(string)
    temp_arr = string.split
    temp_arr.shift
    temp_arr.join(" ")
  end

end















class TodoView

  def initialize(task_controller_s)
    @task_controller = task_controller_s
  end

  def list_all(tasks)
    puts
    puts "___TASKS____________________________________________"
    tasks.each do |task| # Refactor fodder
      task.completed == true ? bool_rep = "[X]" : bool_rep = "[ ]"
      temp_id = ""
      temp_id = " " + task.id.to_s unless task.id > 9
      task.id < 10 ? temp_id = " " + task.id.to_s : temp_id = task.id.to_s
      puts temp_id.to_s + ". #{bool_rep}  #{task.description}"
    end
    puts "----------------------------------------------------"
    puts "Type 'help' for available commands"
    puts "----------------------------------------------------"
    puts
  end

  def list_help
    puts "___HELP_____________________________________________"
    puts "----------------------------------------------------"
    puts "COMMANDS: list, add #, complete #, delete #"
    puts "----------------------------------------------------"
    puts
  end

end











class TodoController

  attr_accessor :db
  attr_reader :the_view, :command, :option

  def initialize(command = nil, option = nil)
    @db = TodoModel.new(self)
    @the_view = TodoView.new(self)

    self.load('task_list.csv') # load pre-existing database

    @command = command.downcase unless command == nil
    @option = option
    process_argv if command
  end

  def process_argv
    if self.command == 'list'
      self.list
    elsif self.command == 'add'
      self.add(option[0])    
    elsif self.command == 'complete'
      self.complete(option[0].to_i)
    elsif self.command == 'delete'
      self.delete(option[0].to_i)
    elsif self.command == 'help'
      self.list_help
    else
      raise "Argument not recognized"
    end  
  end

  def add(task) # Required for problem set
    self.db.add(task)
    puts "Appended \"#{task}\" to your list"
    self.save
  end
  
  def load(file)
    self.db.load(file)
    self.save
  end

  def save(file = 'task_list.csv') # default save file
    self.db.save_to_csv!(file)  
  end

  def list # Required for problem set; DONE
    self.the_view.list_all(self.db.tasks)
  end
  
  def delete(num) # Required for problem set
    self.db.delete_id(num)
    self.list
  end

  def complete(task_id) # Required for problem set
    self.db.complete_id(task_id)
    self.list
  end

  def db_size
    self.db.tasks.length
  end

  def tasks
    self.db.tasks
  end

  def list_help
    self.the_view.list_help
  end
  
end




def main(command, option)
  temp = TodoController.new(command,option)
  temp.save('task_list.csv')
end

main(ARGV[0], ARGV[1..-1])
