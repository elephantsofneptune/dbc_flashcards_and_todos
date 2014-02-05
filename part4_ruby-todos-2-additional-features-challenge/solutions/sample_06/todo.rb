require 'csv'
require 'debugger'

class Task
  attr_reader :description, :complete, :created_at
  attr_accessor :tags

  def initialize(args)
    @description = args[:description]
    @complete = args.fetch(:complete){false}
    @tags = args.fetch(:tags) || []
    @created_at = Time.now
    @completed_at = nil
  end

  def to_array
    [@complete, @description, @created_at, @completed_at, @tags]
  end

  def complete!
    @complete = true
    @completed_at = Time.now
  end

  def complete?
    @complete
  end

  def tag(array)
    @tags << array
  end

  def tags
    @tags
  end

end

class List
  attr_reader :file, :tasks

  def initialize(filename)
    @file = filename
    @tasks = load_tasks(@file)
    self.save
  end

  def load_tasks(file)
    tasks = []
    CSV.foreach(file) do |csv|
      if csv.size > 1
        tasks << Task.new(
          {complete: csv[0], 
           description: csv[1], 
           created_at: csv[2],
           completed_at: csv[3], 
           tags: csv[4]})
      else
        tasks << Task.new({description: csv[0]})
      end
    end
    tasks
  end

  def completed_tasks
    tasks = @tasks.select {|task| task.complete == "true" }
    tasks.sort {|a, b| b.completed_at <=> a.completed_at }
  end

  def outstanding_tasks
    tasks = @tasks.select {|task| task.complete == "false" }
    tasks.sort {|a, b| b.created_at <=> a.created_at }
  end

  def match(task_num)
    @tasks[task_num - 1]
  end

  def add(task)
    @tasks << Task.new({description: task, complete: false})
    self.save
  end

  def delete(task)
    @tasks.delete(task)
    self.save
  end

  def tag(task, new_tags)
    task.tags = new_tags
    self.save
  end

  def complete(task)
    incomplete_task = @tasks.select {|foo| foo == task }
    incomplete_task[0].complete!
    self.save
  end

  def filter(tag)
    tasks = []
    @tasks.each { |task| tasks << task if task.tags.include?(tag) }
    tasks
  end

  def save
    CSV.open(@file, "wb") do |csv|
      @tasks.each { |task| csv << task.to_array }
    end
  end
end

class Controller

  def initialize(list)
    @list = list
  end

  def list
    counter = 1
    @list.tasks.each do |task|
      complete_marker = task.complete? == 'true' ? "x" : " "
      puts "#{counter}. [#{complete_marker}] #{task.description}"
      counter += 1
    end
  end

  def add(task)
    @list.add(task)
    puts "Appended \"#{task}\" to your task list..."
  end

  def delete(task_num)
    task = @list.match(task_num.to_i)
    @list.delete(task)
    puts "Deleted \"#{task.description}\" from your task list..."
  end

  def complete(task_num)
    task = @list.match(task_num.to_i)
    @list.complete(task)
    puts "Completed \"#{task.description}\"..."
  end

  def outstanding
    puts "Outstanding Tasks!"
    outstanding_tasks = @list.outstanding_tasks
    counter = 1
    outstanding_tasks.each do |task|
      puts "#{counter}. #{task.description}"
      counter += 1
    end
  end

  def completed
    puts "Completed Tasks!"
    completed_tasks = @list.completed_tasks
    counter = 1
    completed_tasks.each do |task|
      puts "#{counter}. #{task.description}"
      counter += 1
    end
  end

 def tag(task_num, *tags)
    task = @list.match(task_num.to_i)
    formatted_tags = tags.drop(2)
    @list.tag(task, formatted_tags)
    puts "Tagging task \"#{task.description}\" with tags: #{formatted_tags.join(', ')}"
  end

  def filter(tag)
    puts "Tags that match #{tag}"
    filtered = @list.filter(tag)
    filtered.each do |task|
      show(task)
    end
  end

  def show(task)
    puts task.description
    puts task.created_at
    puts task.tags
  end

  def print
    file = File.new('list.txt', 'w')
    counter = 1
    @list.tasks.each do |task|
      complete_marker = task.complete? == 'true' ? "x" : " "
      file.write("#{counter}. [#{complete_marker}] #{task.description}\n")
      counter += 1
    end
  end
end

controller = Controller.new(List.new('todo.csv'))

if ARGV.any?
  controller.send(ARGV[0].to_sym, ARGV[1], *ARGV) if ARGV[0] == 'tag'
  controller.send(ARGV[0].to_sym, ARGV[1]) if ARGV[0] == 'filter'
  controller.send(ARGV[0].to_sym, ARGV[1]) if ['add','delete','complete'].include?(ARGV[0])
  controller.send(ARGV[0].to_sym) if ['print','list','outstanding','completed'].include?(ARGV[0])
  puts "Not a valid command." if !controller.methods.include?(ARGV[0].to_sym)
else
  puts "Please enter an argument."
end