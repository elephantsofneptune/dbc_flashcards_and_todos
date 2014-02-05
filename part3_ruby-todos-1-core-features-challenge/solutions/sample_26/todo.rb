require 'csv'
 
class Item
  attr_accessor :task, :priority, :completed
  def initialize(task, priority = 0, completed = false)
    @task = task
    
    @priority = priority
    if priority.nil?
      @priority = 0
    end

    @completed = completed
    if completed.nil?
      @completed = false
    end
  end

end

module UserInterface
  def pretty_list
    pretty = []
    list.each_with_index { |item, i| pretty << "#{i+1} - #{item.task}, #{item.priority}, #{item.completed}" }
    pretty
  end
end

module Parser
  def parse_data
    CSV.foreach("todo_list.csv") do |item|
      next if item[0] == "task"
      @list << Item.new(item[0], item[1], item[2])
    end
  end
end

class Todo
  include UserInterface
  include Parser
  attr_reader :list

  def initialize
    @list = []
    parse_data
  end
 
  def add(task)
    @list << Item.new(task)
  end
 
  def delete(item_index)
    @list.delete_at(calculate_item_index(item_index))
  end
 
  def complete(item_index)
    @list[calculate_item_index(item_index)].completed = true
  end
  
  def calculate_item_index(item_index)
    item_index - 1
  end

  def save
    CSV.open("todo_list.csv", "wb") do |csv|
      csv.add_row(["task","priority","completed?"])
      @list.each do |item|
        csv.add_row([item.task, item.priority, item.completed])
      end
    end
  end
end
 
 
todo = Todo.new
input = ARGV
action = input[0]
description = input[1..-1].join(" ")
todo.list if action == "list"
todo.add(description) if action == "add"
todo.delete(description.to_i) if action == "delete"
todo.complete(description.to_i) if action == "complete"
todo.save
