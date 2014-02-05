require 'csv'

class List
  attr_accessor :tasks

  def initialize(csv_file_name)
    @tasks = {}
    @tasks_added = 0
    if File.exists?(csv_file_name)
      @tasks = parse_csv_file(csv_file_name)
    else
      File.open("todo.csv", 'a+')
      @tasks_added = 0
    end
  end

  def parse_csv_file(csv_file_name)
    row_number = 1
    tasks = {}
    CSV.foreach(csv_file_name) do |row|
      tasks[row_number] = Task.new(row[0],status_boolean(row[1]))
      row_number += 1
      @tasks_added += 1
    end
    tasks
  end

  def list
    puts "ID: Task"
    self.tasks.each do |id, task|
      puts "#{id}: [#{task.status ? "X" : " "}] #{task.body}" 
    end
  end

  def add_task(task)
    self.tasks[@tasks_added] = task
    @tasks_added += 1

  end

  def delete_task(task_id)
    self.tasks.delete(task_id)
  end

  def save!
    CSV.open('todo.csv', "wb") do |csv|
      self.tasks.each do |task|
        csv << [task[1].body, task[1].status]
      end
    end
  end

  private

  def status_boolean(status_string_from_CSV)
    status_string_from_CSV == 'true' ? true : false
  end
end

class Task
  attr_reader :body, :status

  def initialize(body, status = false)
    @body = body
    @status = status
  end

  def complete!
    @status = true
  end

end

module Interface
  def self.start
    list = List.new('todo.csv')
    command = ARGV[0].downcase if ARGV[0]
    ARGV.shift
    remainder = ARGV.join(" ")

    case command
      when "list"
        list.list
      when "add"
        Interface::create_task(list, remainder)
      when "delete"
        Interface::delete_task(list, remainder)
      when "complete"
        Interface::complete_task(list, remainder)
      else
        puts "Error"
        puts "List of commands available:"
        puts "ruby todo.rb list"
        puts "ruby todo.rb complete <task_id>"
        puts "ruby todo.rb delete <task_id>"
        puts "ruby todo.rb add <task_name>"
    end
  end

  def self.create_task(list, to_do_text)
    task = Task.new(to_do_text)
    list.add_task(task)
    list.save!
    self.debug(list)
  end

  def self.delete_task(list, task_id)
    list.delete_task(task_id.to_i)
    list.save!
    self.debug(list)
  end

  def self.complete_task(list, task_id)
    list.tasks[task_id.to_i].complete!
    list.save!
    self.debug(list)
  end

  private

  def self.debug(list)
    puts "debug"
    list.list
  end
end

Interface::start
