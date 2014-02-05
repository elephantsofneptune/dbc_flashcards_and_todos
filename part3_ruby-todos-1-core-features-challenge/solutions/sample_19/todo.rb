require 'csv'

# sv_string = CSV.generate do |csv|
#   csv << ["Take out the trash"]
#   csv << ["eat"]
#   csv << ["this is a task item"]
# end


class Item
  attr_accessor :task, :priority, :completed

  def initialize(task, priority = 0, completed = false)
    @task = task
    @priority = priority
    @completed = completed
  end

end





class Todo

  def initialize
    @list = []
    parse_data
  end

  def add(task)
    @list << Item.new(task)
  end

  def delete(item)
    @list.delete_at(item - 1)
  end

  def complete(item)
    @list[item - 1].completed = true
  end

  def list
    @list.each_with_index { |item, i| puts "#{i+1} - #{item.task}, #{item.priority}, #{item.completed}"}
  end

  def parse_data
    CSV.foreach("todo_list.csv") do |row|
      next if row[0] == "task"
      @list << Item.new(row[0], row[1], row[2])
    end
  end

  def save
    CSV.open("todo_list.csv", "wb") do |csv|
      csv << ["task","priority","completed?"]
      @list.each do |item|
        csv << [item.task, item.priority, item.completed]
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

# todo.list
# todo.delete(3)
# todo.list
# todo.complete(1)
# todo.list
# todo.add("Take out the trash")
# todo.add("Give Eric Feedback")
# todo.delete("1")
# todo.list
# todo.completed("1")  