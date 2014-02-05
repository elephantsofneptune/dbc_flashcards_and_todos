require 'csv'
ATTRIBUTES = [:id, :content, :status]

class Task

  
  attr_accessor :id, :content, :status

  def initialize(attributes = {})
    @id = attributes[:id]
    @content = attributes[:content]
    @status = attributes[:status] || 'Open'
  end

  def to_s
    self.to_a.join(". ")
  end
 
  def to_a
    ATTRIBUTES.map { |attrib| self.send(attrib) }
  end

end

class List

  attr_reader :file, :tasks
 
  def initialize(task_file)
    @file = task_file
    @tasks = nil
  end
 
  def tasks
    # puts ".tasks has been called on the list"
    # If we've already parsed the recipe CSV file, don't parse it again.
    return @tasks if @tasks
    
    # We've never called recipes before, so we need to parse the CSV file
    # and return an Array of Recipe objects here.  
    @tasks = []
    read_data(@file)
    @tasks
  end
 
  def read_data(file)
    CSV.foreach(file, { :headers => true, :header_converters => :symbol} ) do |task_data|
      # p task_data
      @tasks << Task.new(task_data)
    end
  end

  def write_data(file)
    CSV.open(file, 'w') do |csv|
      csv << ATTRIBUTES
      @tasks.each do |task|
        csv << task.to_a
      end
    end
  end

  def add_task(task)
    # puts "I added a task"
    @tasks << task
  end

  def complete_task(id)
    # puts "I called .complete_task"
    @tasks.each do |task| 
      if task.id == id  
        # puts "I found the task with the right id"
        task.status = "Done" 
      end
    end
  end

  def delete_task_by_id(id)
    @tasks.reject! { |task| task.id ==id }
    self.reorder_ids
  end

  def reorder_ids
    index = 1
    @tasks.each do |task|
      task.id = index.to_s
      index += 1
    end
  end


end


class TodoInterface

  def initialize(task_list)
    @todos = task_list
    @todos.tasks
  end

  def convert_input_to_task(argument)
    task = argument.join(" ")
    {:id => @todos.tasks.last.id.to_i + 1, :content => task, :status => 'Open'}
  end

  def list_tasks
    # puts "List tasks called"
    puts @todos.tasks 
  end

  def add_task_from_user(task)
    new_task = convert_input_to_task(task)
    # puts new_task
    @todos.add_task(Task.new(new_task))
  end

  def mark_complete(id)
    # puts "I called .mark_complete"
    @todos.complete_task(id)
  end

  def delete_task(id)
    @todos.delete_task_by_id(id) 
  end 

  def update_csv_file
    @todos.write_data('todo.csv')
  end 


end

ACTIONS = ['list', 'add', 'delete', 'complete']  

def valid_command(command)
  if ACTIONS.include?(command)
    command
  else
    raise "That is not a valid action"
  end 
end


header_line = "_______Your TO-DO List: _______"

#Driver code

#parse ARGV
command = ARGV[0]
argument = ARGV[1..-1]

# Initialize objects
our_list = List.new('todo.csv')
interface = TodoInterface.new(our_list)
# Check for valid command
valid_command(command)
# Perform action
if command.include?('add')
  interface.add_task_from_user(argument)
elsif command.include?('complete')
  interface.mark_complete(argument[0])
elsif command.include?('delete')
  interface.delete_task(argument[0])
end
puts header_line
interface.list_tasks
# Save updated
interface.update_csv_file




