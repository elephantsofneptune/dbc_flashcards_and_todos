require 'csv'

class Task
  attr_reader    :text
  attr_accessor  :complete

  def initialize(text, complete = false)
    @text = text
    @complete = complete
  end
  
  def update_status
    @complete = true
  end

  def view
    "#{@complete ? '[X]' : "[_]"} #{@text}"
  end

  def to_a
    [text,complete]
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

  def view
    count = 1
    @list.each do |task| 
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
      @list << Task.new(row[0], to_boolean(row[1]))
    end
  end

  def to_boolean(string)
    string == 'true'
  end
end

class Run
 
  def initialize
    @list = List.new
  end

  def run!
    if ARGV.any?  
      @list.upload_list('todo.csv') 
      case ARGV[0]
      when 'add'
        @list.add_task(ARGV[1..-1].join(' '))
      when 'delete'
        @list.delete_task(ARGV[1..-1].join(' '))
      when 'list'
        @list.view
      when 'complete'
        @list.complete(ARGV[1..-1].join(' '))
      else
        "no method for that"
      end
      @list.save('todo.csv')
      @list.save_human_copy
    end
  end
end



todo = Run.new
todo.run!