require 'CSV'
require 'date'

class Task

  attr_reader :index, :status, :todo, :creation_date, :completion_date
  attr_accessor :tags
   

  def initialize(args)
    @index = args[:index]
    @todo = args[:todo]
    @status = args[:status]
    @creation_date = DateTime.parse(args[:creation_date] || Date.today.to_s)
    @completion_date = args[:completion_date]
    @tags = args[:tags]
  end

  def incomplete?
    self.status == 'incomplete'
  end

  def completed?
    self.status == 'complete'
  end
end

class TaskList

  attr_reader :tasks

  def initialize()
    @tasks = []
  end

  def created_first
    tasks.sort_by do |task|
      task.creation_date
    end
  end

  def completed_first
    tasks.sort_by do |task|
      task.completion_date
    end.reverse
  end

  # outstanding tasks are always oldest first
  def outstanding
    created_first.select do |task|
      task.incomplete?
    end
  end

  def completed
    completed_first.select do |task|
      task.completed?
    end
  end

  def find_task_by_index(index)
    tasks.find { |task| task.index == index }
  end

  def filter(tag)
    # tasks.each { |task| p task.tags if task.tags.include?(tag) } 
    tasks.select { |task| task.tags.include?(tag) }
  end  
end



class TodoApp
  def initialize
    @task_list = TaskList.new

    CSV.foreach('todo2.csv', :headers => true, :header_converters => :symbol) do |csv|
      @task_list.tasks << Task.new(csv.to_hash)
    end
  end

  def handle_input(command)
    output_buffer = ""
    if command[0] == "list:outstanding"
      output_buffer += "Outstanding Todo's sorted by creation date! \n\n"

      @task_list.outstanding.each do |task|
        output_buffer += pretty_task(task)
      end
    elsif command[0] == "list:completed"
      output_buffer += "Completed Todo's sorted by completion date! \n\n"

      @task_list.completed.each do |task|
        output_buffer += pretty_task(task)
      end
    elsif command[0] == "tag"
      task = @task_list.find_task_by_index(command[1])
      if task
        task.tags = command[2..-1]
        output_buffer += "Tagging task '#{task.todo}' with tags: #{task.tags.join(" ")}" 
      else
        output_buffer += "No such Todo exists"
      end
    elsif command[0].include?('filter')
      tag_filter = command[0].split(':')
      tag = tag_filter[1]
      

      @task_list.filter(tag).each do |task|
        output_buffer += "#{task.todo} [#{tag}] \n\n"
      end
    end

    output_buffer
  end
  

  private


  def pretty_date(date)
    date.strftime("%m/%d/%Y")
  end

  def pretty_task(task)
    "#{task.index}. #{task.todo} - #{task.status} - #{pretty_date(task.creation_date)}\n"
  end
end

app = TodoApp.new
puts app.handle_input(ARGV)