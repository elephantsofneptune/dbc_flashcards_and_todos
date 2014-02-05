require 'csv'
class List
  attr_reader :list,:file
	def initialize(file)
		@file = file
		@list = []
	end

	def grab_tasks
	CSV.foreach(file) do |row|
		item = Item.new(row[0],row[1])
		list << item
	end
end
	
	def show_items
	list.each_with_index do |item,index|
		puts "#{index+1}. #{item.description}" 
	end
end

	def save
	CSV.open(file,"w") do |csv|
		list.each do |item|
		csv << item.to_a
		end
	end
	end	
	
	def add_item(new_item_description)
	list << Item.new(new_item_description)
	puts "Appended \"#{new_item_description}\" to your TODO list \n"
	end

	def delete_item(index)
	deleted_item = list.delete_at(index-1)
    puts "Deleted \"#{deleted_item.description}\" from your TODO list"
	end
end

class Item
	attr_reader :description,:status
	def initialize(description,status="incomplete")
		@description = description
		@status = status
	end 

	def to_a
		[description,status]
	end

end


new_list = List.new("todo.csv")
new_list.grab_tasks
if ARGV[0] == "list"
	puts "Here is your list of Items: "
	new_list.show_items
end	
if ARGV[0] == "add"
	new_list.add_item(ARGV[1..-1].join(" "))
	new_list.save
end
if ARGV[0] == "delete"
	new_list.delete_item(ARGV[1].to_i)
	new_list.save
end