
# todo.rb __1__(add, list, delete,complete) __2__(OPTIONAL words- task to add,remove, or complete)
# how to write in two options

require 'CSV'

# class Controller 

#   def load_csv_file(filepath)
#     csv_file = File.open(filepath)
#     #give me a list
    
#     todo_list = todo.new(list)
#     csv_file.each_with_index do |task, index|
#       puts "#{index +1}. #{task}"
#     end
#   end

# end


# class Task
#   # task_id, text_body/ content
#   attr_reader :task_item

#   def initialize(tasks)
#     @task_item = tasks
#   end
# end



class List
  # showlist, add, edit, delete, sort, complete
    
    attr_reader :list, :task_to_add, :user_input, :user_task_input

    def initialize
      @list = []
      @user_input = ARGV
      @user_command = @user_input.shift
      @user_task_input = @user_input.join(" ")
    end
##############################
    def add_to_list(task)
      if @user_command == "add"
        @list << task
        @list
      end
    end

    def delete_item!
      if @user_command == "delete"
        @list = @list.reject {|task| task == @user_task_input}
      end
    end

    def print_list
      @list.each_with_index do |task, index|
        puts "#{index +1}. #{task}"
      end
    end
end

# taskmebro = Task.new("Hello world")  
# p taskmebro.task_item


ryans_list = List.new
# p ryans_list
p ryans_list.user_task_input
p ryans_list.add_to_list("hello")
# p ryans_list.add_to_list("Shut-up world!")
p ryans_list.add_to_list("nooooooo")
# p ryans_list.list
# p ryans_list.print_list
# p ryans_list.delete_item!
p ryans_list.print_list






























# user_input = ARGV
# #Command to pass to prgram
# user_command = user_input.shift
# user_task_input = user_input.join(" ")

# case user_command
# when "add"
#   p "you are trying to add '#{user_task_input}'"
# when "list"
#   p "you are trying to see all your tasks"
# when "delete"
#   p "you are trying to delete '#{user_task_input}'"
# when "complete"
#   p "you are trying to complete '#{user_task_input}'"
# else
#   puts "Please use one of the following commands: \n'add' \n'list' \n'delete' \n'complete'"
# end


# thing = ARGV 

# stuff = File.open(thing.join(" "))

# p thing
# # p stuff

# class Todo
#   def initialize(filename)
#     @filename = filename
#   end
#   # ARGV[0] == "list"
#   def load_csv_file(filepath)
#     csv_file = File.open(filepath)
   
#     csv_file.each_with_index do |task, index|
#       puts "#{index +1}. #{task}"
#     end
#   end

# new = Controller.new
# new.load_csv_file('todo.csv')