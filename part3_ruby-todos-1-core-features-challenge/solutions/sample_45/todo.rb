require 'CSV'


class CSVFile

 def self.update_CSV_file(file_location, todo_object)
  File.open(file_location, 'w') do |file| 

    todo_object.each do |task|
      file.write(task)
      file.write("\n")
    end
  end
end
end


class ToDo
  attr_reader :tasks

  def initialize(file_location)
    @tasks = get_list(load_CSV_file(file_location)) # contains task objects, read from CSV
  end

  def get_list(array_of_task_lines)
    array_of_task_lines.map!{|item| Task.new(item[0]) }
  end

  def add!(task_string)
    @tasks << Task.new(task_string)
  end

  def edit!(task_num, task_string)
    @tasks[task_num - 1].change_action(task_string) 
  end

  def delete!(task_num)
    @tasks.delete_at(task_num - 1)
  end

  def load_CSV_file(file_location)
    @tasks_lines_in_arrays = []
    CSV.foreach(file_location) { |row| @tasks_lines_in_arrays << row }
    @tasks_lines_in_arrays
  end
end

class Task
  attr_reader :action

  def initialize(string)
    @action = string
  end

  def change_action(new_action)
    @action = new_action
  end

  def to_s
    "#{action}"
  end
end

class View
  attr_reader :list_object
  def initialize(to_do_object)
    @list_object = to_do_object
  end

  def display
    @list_object.tasks.each_with_index do |task, index|
      puts "#{index + 1}: #{task}"
    end
  end
end


class Controller
  attr_reader :commands, :name_of_Todo_list

  def initialize(name_of_Todo_list, file_name)
    @file_name = file_name
    @name_of_Todo_list = name_of_Todo_list
    @name_of_Todo_list = ToDo.new(file_name)
  #@commands returns the commands as strings in an array
  def run!
    execute_command
  end

  def execute_command
    @commands = ARGV[0]
    case commands
      when "list"
      console_view = View.new(@name_of_Todo_list)
      console_view.display
      when "add"
        @name_of_Todo_list.add!(ARGV[1]) #maybe need to fix, string adding to to_do needs to be written as a string
        CSVFile.update_CSV_file(@file_name, @name_of_Todo_list.tasks)
      when "delete"
        task_num = ARGV[1].to_i
        @name_of_Todo_list.delete!(task_num)
        CSVFile.update_CSV_file(@file_name, @name_of_Todo_list.tasks)
      when 'edit'
        task_num = ARGV[1].to_i
        new_action = ARGV[2]
        @name_of_Todo_list.edit!(task_num, new_action)
        CSVFile.update_CSV_file(@file_name, @name_of_Todo_list.tasks)
      else
        puts "Please say a real commmand!"
      end
    end
  end

end

my_program = Controller.new("annies_list", 'todo.csv')
my_program.run! #runs the program for the most place
my_program.commands #prints out commands in 

# TEST CODE!

# p CSVFile.new.load_CSV_file('todo.csv') # Returns array of to_do items

# p Task.new("Go to the grocery store").action

# p ToDo.new([['go to the store'],['buy some cookies, because that shit is straight up delicious']])

# ALWAYS HERE

# annies_list = ToDo.new('todo.csv')
# annies_list.tasks

# # show
# # annies_list.tasks.each{|task| p task.action}

# # add
# annies_list.add!("Go running")
# # puts annies_list.tasks

# # edit
# annies_list.edit!(3, "Take the dog for a walk")
# annies_list.edit!(2, "anythingatall")
# # puts annies_list.tasks

# # delete
# annies_list.delete!(1)
# puts annies_list.tasks

#  # __END__

# # VIEW Class
# # console_view = View.new(annies_list)
# # console_view.display #displays to do list with indices

# # update csv file

# CSVFile.update_CSV_file('todo.csv', annies_list.tasks)
