require 'yaml'

class ToDoList

  def initialize(input)
    @action = input[0]
    @task_info = Task.new(input[1..-1].join(" "))
    @task_list = []
    load_list if File.exists?('./task_list.yml')
    waterspider
  end


  private 

  def waterspider
    case
      when @action == "add"
        add_item
      when @action == "delete"
        delete_item
      when @action == "complete"
        complete_item
      else
        list_items
    end
  end

  def save_list
    File.open('./task_list.yml','w') do |task|
      task.puts @task_list.to_yaml
    end
  end

  def load_list
    @task_list = YAML::load(File.open('./task_list.yml','r'))
  end
  
  def add_item
    @task_list << @task_info
    save_list
  end

  def delete_item
    @task_list.delete_if { |item| item.task_info == @task_info.task_info }
    save_list
  end

  def list_items
    @task_list.each do |task|
      puts task.print
    end
  end

  def complete_item
     completed_item = @task_list.select {|item| item.task_info == @task_info.task_info }
     completed_item.first.status = true 
     save_list
  end

  def delete_all
  end


end

class Task

  attr_reader :task_info
  attr_accessor :status

  def initialize(task_info)
    @task_info = task_info
    @status = false
  end

  def print
    @status == true ? "[X] #{task_info}" : "[ ] #{task_info}"
  end

end

user_input = []

ARGV.each do |word|
  user_input << word
end

ToDoList.new(user_input)
