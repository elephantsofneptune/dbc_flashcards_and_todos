require 'CSV'

class Task
  attr_accessor :text, :completed, :tags

	def initialize(text, completed = false, tags = [])
		@text = text
		@completed = completed
		@tags = tags
	end

	def printTags
		tags.map {|t| "[#{t}]"}.join(' ')
	end
end

class List
	attr_reader :tasks

	def initialize
		@tasks = []
	end

	def add task
		@tasks << task
	end

	def delete task
		@tasks.delete(task)
	end

	def print
		tasks.each_with_index do |task, index|
			tags_string = task.tags
		end
	end
end

class Interface
	attr_reader :list

	def initialize
		@file = ('database.csv')
		@list = List.new
	end

	def getCommand
		ARGV[0]
	end

	def getTaskAddText
		ARGV[1..-1].join(' ')
	end

	def getItemID
		ARGV[1].to_i - 1
	end

	def getTags
		ARGV[2..-1]
	end

	def getExportName
		ARGV[1].to_s
	end

	def print filter = nil
		list.tasks.each_with_index do |task, index|
			if filter == nil
				puts "#{index+1}. #{task.text}" + (task.completed ? " (completed)" : "") +  " #{task.printTags}"
			else
				puts "#{index+1}. #{task.text} #{task.printTags}" if task.completed == filter || task.tags.include?(filter)
			end
		end
	end

	def loadDatabase
		CSV.foreach(@file) do |line|
			list.add(Task.new(line[0], (line[1] == 'true' ? true : false), line[2..-1]))
		end
	end

	def saveDatabase
		CSV.open(@file, 'w') do |line|
			list.tasks.each do |item|
				line << [item.text, item.completed] + item.tags
			end
		end
	end

	def exportDatabase filename
		File.open(filename + '.txt', 'w') do |line|
			list.tasks.each_with_index do |task, index|
				line << "#{index+1}. [#{task.completed ? "x" : " "}]  #{task.text} #{task.printTags}\n"
			end
		end
	end
end

myInterface = Interface.new
myInterface.loadDatabase

task_by_ID = myInterface.list.tasks[myInterface.getItemID]

case myInterface.getCommand
when "add"
	myInterface.list.add(Task.new(myInterface.getTaskAddText))
	puts "Appended \"#{myInterface.getTaskAddText}\" to your TODO list..."
when "list"
	myInterface.print
when "list:outstanding"
	myInterface.print(false)
when "list:completed"
	myInterface.print(true)
when "filter"
	myInterface.print(myInterface.getExportName)
when "tag"
	task_by_ID.tags = myInterface.getTags + task_by_ID.tags
	puts "Updated \"#{task_by_ID.text}\" to include #{task_by_ID.printTags} tags..."
when "delete"
	myInterface.list.delete(task_by_ID)
	puts "Deleted \"#{task_by_ID.text}\" from your TODO list..."
when "completed"
	task_by_ID.completed = true
	puts "Updated \"#{task_by_ID.text}\" to completed on your TODO list..."
when "export"
	myInterface.exportDatabase(myInterface.getExportName)
	puts "Exported your TODO list as \"#{myInterface.getExportName}.txt\"..."
end

myInterface.saveDatabase