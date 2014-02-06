require "CSV"

class List
  attr_reader :command, :output, :tasks
  def initialize
    @command = ARGV.shift
    implement_command
  end

  def implement_command
    case command
    when "list"
      list_tasks
    when "add"
      add
    when "delete"
      delete
    when "complete"
      complete
    end
  end 

  def list_tasks
    i = 1
    CSV.foreach("to_do.csv") do |row|
      status = row[0]
      task = row[1]
      puts "#{i}. #{status} #{task}"
      i += 1
    end
  end

  def add 
    new_task = Task.new([ARGV.join(" ")])
    CSV.open("to_do.csv", "a") do |csv|
      csv << ["Do", new_task.name.join(" ")]
    end
  end

  def delete
    delete_index = (ARGV[-1].to_i - 1)
    csv_array = CSV.read("to_do.csv")
    csv_array.delete_at(delete_index)
    CSV.open("to_do.csv", "w+") do |csv|
      csv_array.each do |task|
        csv << task
      end
    end
  end

  def complete
    complete_index = (ARGV[-1].to_i - 1)
    csv_array = CSV.read("to_do.csv")
    csv_array[complete_index][0] = "Done"
    CSV.open("to_do.csv", "w+") do |csv|
      csv_array.each do |task|
        csv << task
      end
    end
  end
end


class Task
  attr_reader :name
  attr_accessor :status 

  def initialize(task)
    @name = task
    @status = :do
  end
end
test = List.new
