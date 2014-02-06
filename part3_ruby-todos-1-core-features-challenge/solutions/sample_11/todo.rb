def run(list)
  Controller.parse(list)
  argument = ARGV[2..-1].join(' ')
  command = ARGV[1]
  if command == "add"
    Controller.add(argument, list)
  elsif command == "delete"
    Controller.delete(argument.to_i, list)
  elsif command == "view"
    Controller.view(list)
  elsif command == "completed"
    Controller.completed(argument.to_i, list)
  end
  Controller.save(list, 'todo.csv')
end

require 'csv'

class Item
  attr_reader :task
  def initialize(task)
    @task = task
    @completed = false
  end
end

class List
  attr_reader :csv_list
  attr_accessor :item_set
  def initialize(csv_list)
    @csv_list = csv_list
    @item_set = []
  end
end

class Controller
  def self.parse(list)
    CSV.foreach(list.csv_list) do |row|
      new_item = row.first
      Controller.le_shovel( Item.new(new_item), list )
    end
  end

  def self.view(list)
    list.item_set.each { |item| puts item.task }
    return nil
  end

  def self.save(list, filename)
    CSV.open(filename, 'w') do |csv|
      list.item_set.each do |item|
        csv << [item.task]
      end
    end
  end

  def self.le_shovel(item, list)
    list.item_set << item
  end

  def self.add(item, list)
    Controller.le_shovel( Item.new("[ ] #{item}"), list )
  end

  def self.delete(index, list)
    list.item_set.delete_at(index)
  end

  def self.completed(index, list)
    list.item_set[index].task.sub!(/\[ \]/, "[X]")
  end

end

list = ARGV[0]
le_list = List.new(list)
run(le_list)
