require 'csv'
require 'chronic'

class Item
  attr_accessor :task, :date_to_be_completed, :completed, :creation_date

  def initialize(input, date_to_be_completed = 0, creation_date = Time.now)
    if input.class == CSV::Row
      @task = input[:task]
      @date_to_be_completed = input[:date_to_be_completed]
      @completed = input[:completed]
      @creation_date = input[:creation_date]
    else
      @task = input
      @date_to_be_completed = Chronic.parse(date_to_be_completed)
      @completed = false
      @creation_date = creation_date
    end
  end

end

class Todo

  def initialize(file)
    @list = FileIO.read_parse_csv(file)
  end

  def add(task, date_to_be_completed)
    @list << Item.new(task, date_to_be_completed)
  end

  def delete(item)
    @list.delete_at(item - 1)
  end

  def complete(item)
    @list[item - 1].completed = true
  end

  def list
    sorted_list = @list.sort_by {|item| item.date_to_be_completed}
    sorted_list.each_with_index { |item, i| puts "#{i+1} - #{item.task} due on #{item.date_to_be_completed}. You created this task on #{item.creation_date}, and it is currently #{item.completed == true ? 'completed' : 'not completed'}"}
  end

  def save!
    FileIO.save(@list)
  end
end

class FileIO
  def self.read_parse_csv(file)
    all_items = []
    CSV.foreach(file, {:headers => true, :header_converters => :symbol}) do |row|
      all_items << Item.new(row)
    end
    all_items
  end

  def self.save(list)
    CSV.open("todo.csv", "wb") do |csv|
      csv << ["task", "date to be completed", "completed?", "creation date"]
      list.each do |item|
        csv << [item.task, item.date_to_be_completed, item.completed, item.creation_date]
      end
    end
  end
end

todo = Todo.new("todo.csv")
input = ARGV
action = input[0]
non_action_input = input[1..-1].join(" ")
description = non_action_input.partition(",")[0].strip
date_to_be_completed = non_action_input.partition(",")[2].strip
tags = input[1..-1]
todo.send action if todo.method(action.to_sym).arity == 0
todo.send action, description if todo.method(action.to_sym).arity == 1
todo.send action, description, date_to_be_completed if todo.method(action.to_sym).arity == 2
todo.save!

