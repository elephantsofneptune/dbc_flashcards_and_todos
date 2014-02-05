require 'csv'
 
class Parser
  attr_accessor :list
 
  def initialize(file)
    @file = file 
    @list = []
    parse_list
  end 
 
  def parse_list
    CSV.foreach(@file) do |row|
      @list << Task.new(row[0]) unless row.empty?
    end
  end
 
end
 
class Task
  attr_reader :string
 
  def initialize(string)
    @string = string
  end
end
 
 
class ToDoList
    attr_accessor :list
    def initialize(list)
      @list = list
    end
 
    def show_list
      @list.each{|task_object| puts task_object.string} 
 
    end
 
    def add(task)
      @list << Task.new(task)
    end
 
    def delete(num)
     @list.delete_at(num-1)
    end
end
 
class Controller 
  def self.run
 
    include View 
 
    file = Parser.new('todo.csv')
    parsed_file = file.list
 
    my_list = ToDoList.new(parsed_file)
 
    response = ARGV
    method = response.shift
    command = response.join(" ")
 
    case method 
    when 'list'
       my_list.show_list
    when 'add'
      my_list.add(command) 
      View.add(command)
    when 'delete'
      command = command.to_i
      test = my_list.delete(command)
 
    end

    CSV.open('todo.csv', 'w') do |file|
      my_list.list.each do |item|
        file << [item.string]
      end
    end
 
  end
end
 
module View
  def self.add(command)
    puts "Appended '#{command}' to your TODO list..."
  end
  def self.delete(command)
    puts "Deleted '#{command}' from your TODO list..."
  end
end
 
Controller.run 
