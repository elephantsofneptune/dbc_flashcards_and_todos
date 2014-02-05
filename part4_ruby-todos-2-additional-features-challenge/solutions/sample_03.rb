require 'csv'

class List 

  def initialize
    @tasks = []    
  end

  def run!
    load_file
    parse_argv 
    save_file unless @tasks.empty?
  end

  def parse_argv
    method = ARGV[0].dup
    if method.include?('filter:') 
      method = method.split(':') 
      self.send(method[0],method[1])
      return
    end
    method.slice!('list:')
    self.send(method, ARGV[1..-1].join(' '))
  end

  def add(new_task)
    @tasks << Task.new(["[ ]",new_task])
    puts "Added '#{new_task}' to To Do List"
  end

  def outstanding(tasks)
    @tasks.each { |task| puts task if task.status == '[ ]' }
  end

  def completed(tasks)
    @tasks.each{|task| puts task if task.status == '[X]'}
  end

  def tag(tags)
    tags = tags.split(/ /)
    @tasks[(tags[0].to_i)- 1].add_tags(tags[1..-1])
  end

  def filter(tag)
    @tasks.each{|task| puts task if task.tags.include?(tag)}
  end

  def complete(num)
    @tasks[num.to_i-1].complete_task
    puts "Completed Task #{num}"
  end

  def delete(task_id)
    @tasks.delete_at(task_id.to_i-1)
    puts "Delete Task #{task_id}"
  end

  def list(no_arg)
    @tasks.each_with_index { |task,index| puts "#{index+1}. #{task} Tags: #{task.tags}" } unless @tasks.empty?
  end

  private

    def save_file
      CSV.open('todo2.csv', 'w') do |csv|
        @tasks.each { |task| csv << [task.status, task.task_item,task.tags] }
      end
    end

    def load_file
      CSV.foreach('todo2.csv') { |row| @tasks << Task.new(row) }
    end
end

class Task
  attr_reader :status, :task_item, :tags
  attr_accessor :status
  def initialize(args)
    @status = args[0]
    @task_item = args[1]
    @tags = args[2] || ''
  end

  def to_s
   "#{@status} #{@task_item}"
  end

  def complete_task
    @status = "[X]"
  end

  def add_tags(args)
    @tags += " #{args.join(' ')}"
  end
end

if ARGV.any?
  list = List.new
  list.run!
end



