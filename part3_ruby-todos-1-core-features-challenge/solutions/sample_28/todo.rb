require 'csv'

class List 

  def initialize
    @tasks = []    
  end

  def run!
    load_file
    parse_argv 
    save_file
  end
  
  def parse_argv
    self.send(ARGV[0], ARGV[1..-1].join(' '))
  end

  def add(new_task)
    @tasks << Task.new(["#{@tasks.length + 1} [ ] #{new_task}"])
  end

  def complete(num)
    @tasks[num.to_i-1].complete
  end

  def delete(task_id)
    @tasks.delete_at(task_id.to_i-1)
  end

  def save_file
    CSV.open('todo.csv', 'w') do |csv|
      @tasks.each_with_index do |task, index|
        csv << ["#{index + 1}. #{task.completed} #{task.task_item}"]
      end
    end
    p "Save file"
  end

  def list(no_arg)
    @tasks.each { |task| puts task}
  end

  def load_file
    CSV.foreach('todo.csv') do |row|
      @tasks << Task.new(row)
    end
    @tasks
  end

end

class Task
  attr_reader :id, :task_item, :completed
  def initialize(args)
    @id = args.join.match(/^(\d+)/)[1].to_i
    @task_item =  args.join.match(/\s+(\b(\w|\s|.*)+\b)/)[1]
    @completed = args.join.match(/(\[ \])|(\[X\])/)[1] || args.join.match(/(\[ \])|(\[X\])/)[2]
  end

  def to_s
   "#{@id}. #{@completed} #{@task_item}"
  end

  def complete
    @completed = '[X]'
  end
end

if ARGV.any?
  list = List.new
  list.run!
end



