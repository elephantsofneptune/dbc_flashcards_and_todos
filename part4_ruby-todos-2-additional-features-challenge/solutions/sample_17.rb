# Solution for Challenge: Ruby Todos 2.0: Additional Features. Started 2013-05-03T06:42:21+00:00

require 'csv'

class Task
  attr_reader    :text
  attr_accessor  :complete, :tags

  def initialize(text, complete = false, tags = [])
    @text = text
    @complete = complete
    @tags = tags
  end
  
  def update_status
    @complete = true
  end

  def view
    "#{@complete ? '[X]' : "[_]"} #{@text}"
  end

  def to_a
    [@text,@complete,@tags]
  end

  def add_tag(new_tags)
    new_tags.each do |new_tag|
      @tags << new_tag if !@tags.include?(new_tag)
    end
  end
end

class List
  attr_reader :list

  def initialize
    @list = []
  end

  def add_task(text)
    task = Task.new(text)
    @list << task
  end

  def view(list = @list)
    count = 1
    list.each do |task| 
      puts "#{count}. #{task.view}"
      count += 1
    end
  end

  def delete_task(task_text)
    @list.delete_if { |task| task.text == task_text }
  end

  def complete(task_text)
    @list.each { |task| task.update_status if task.text == task_text }
  end

  def save(filename)
    CSV.open(filename, "w+", :col_sep => ", ") do |csv|
      @list.each {|task| csv << task.to_a }
    end  
  end

  def save_human_copy
    count = 1
    File.open('todo.txt', "w+") do |row|
      @list.each  do|task| 
        row << "#{count}. #{task.view}\n"
        count += 1
      end
    end
  end

  def upload_list(filename)
    CSV.foreach(filename, :col_sep => ", ") do |row|
      @list << Task.new(row[0], to_boolean(row[1]), row[2])
    end
  end

  def to_boolean(string)
    string == 'true'
  end

  def outstanding
    @list.clone.delete_if do |task|
      task if task.complete
    end
  end

  def completed
    @list.clone.delete_if do |task|
      task if !task.complete
    end
  end

  def add_tags(task,tags)
    @list.each_with_index do |list_task, index|
      list_task.add_tag(tags) if index == task
    end
  end

  def display_filtered(filter)
    count = 1
    @list.each do |task| 
      puts "#{count}. #{task.view}" if task.tags.include?(filter)
      count += 1
    end
  end
end

class Run
 
  def initialize
    @todolist = List.new
  end

  def run!
    if ARGV.any?  
      @todolist.upload_list('todo.csv') 
      case 
      when ARGV[0] == 'add'
        @todolist.add_task(ARGV[1..-1].join(' '))
      when ARGV[0] == 'delete'
        @todolist.delete_task(ARGV[1..-1].join(' '))
      when ARGV[0] == 'list'
        @todolist.view
      when ARGV[0] == 'list:completed'
        @todolist.view(@todolist.completed)
      when ARGV[0] == 'list:outstanding'
        @todolist.view(@todolist.outstanding)
      when ARGV[0] == 'complete'
        @todolist.complete(ARGV[1..-1].join(' '))
      when ARGV[0] == 'tag'
        @todolist.add_tags(ARGV[1].to_i - 1, ARGV[2..-1])
      when ARGV[0] =~ /[filter]/
        @todolist.display_filtered(ARGV[0].gsub("filter:", ""))
      else
        "no method for that"
      end
      @todolist.save('todo.csv')                  
      @todolist.save_human_copy
    end
  end
end

todo = Run.new
todo.run!