require 'csv'

class List
 
  def initialize(controller,list_name = "todo")
    @file_name = "#{list_name}.csv"
    @controller = controller
    refresh_list 
  end

  def refresh_list
    @entries = @controller.convert_file_to_array(@file_name)
  end

  def print_list
    @entries.each_with_index do |entry, index| 
      puts "#{index+1}. " + entry.to_s
    end 
  end
  
  def add(entry)
    @controller.add_to_file(entry,@file_name)
    @entries << entry
  end

  def delete(entry)
    @controller.delete(entry,@file_name)
    refresh_list
  end

  def how_many_completed 
    @entries.count {|entry| entry.completed == "[COMPLETED]"}
  end

  def complete(task)
    @controller.complete(task,@file_name)
    refresh_list
  end

  def assign_id
    num = 1
    all_ids = @entries.map {|entry| entry.id.to_i}
    num = rand(1000) while all_ids.include?(num)
    num.to_s
  end
end


class Entry
  attr_reader :task, :id
  attr_accessor :completed
  def initialize(task, id,comp = nil)
    @task = task
    @completed = comp || "[INCOMPLETE]"
    @id = id
  end

  def to_s
    "#{task}: #{completed} ID no.: #{id}"
  end
  
  def to_csv
    "#{task},#{completed},#{id}"
  end
end


class Controller

  def open(list_file)
    File.open(list_file, "a")
  end

  def clear_file(file_name)
    @list_file = File.open(file_name, "w")
  end

  def convert_file_to_array(list_file)
    opened_file = open(list_file)
    entries = []
    CSV.read(opened_file).each do |row|
        entries << Entry.new(row[0],row[2],row[1])
    end
    entries
  end

  def add_to_file(entry,file)
    opened_file = open(file)
    opened_file << entry.to_csv + "\n" 
  end

  def delete(task, file)
    entries = convert_file_to_array(file)
    clear_file(file)
    entries.select!{|entry| entry.task != task}
    entries.each {|entry| add_to_file(entry,file)}
  end

  def complete(task, file)
    entries = convert_file_to_array(file)
    clear_file(file)
    index = entries.index {|entry| entry.task == task}
    entries[index].completed = "[COMPLETED]"
    entries.each {|entry| add_to_file(entry,file)}
  end
end

 
input = ARGV
current_controller = Controller.new
current_list = List.new(current_controller)
secondary_input = input[1..input.length].join(" ")

case input[0].downcase
when "add"
  new_entry = Entry.new(secondary_input,current_list.assign_id)
  current_list.add(new_entry)
  puts "Appended #{secondary_input}"
when "list"
  current_list.print_list
when "delete"
  current_list.delete(secondary_input)
  p "Deleted #{secondary_input}"
when "complete"
  current_list.complete(secondary_input)
  p "Completed #{secondary_input}"
else 
  p "Effed up"
end


