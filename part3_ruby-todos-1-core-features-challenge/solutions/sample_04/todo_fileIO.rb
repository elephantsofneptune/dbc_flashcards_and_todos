require 'csv'

module CSVParser

  def read_csv
    CSV.foreach(filename) do |row|
      task_info = parse_row(row)
      list.add(Task.new(task_info.description, task_info.complete || false))
    end
  end

  TaskInfo = Struct.new(:description, :complete)
  def parse_row(row)
    TaskInfo.new(row[0], row[1])
  end

  def write_csv
    CSV.open(filename, "w") do |csv|
      list.tasks.each do |task|
        csv << [task.description, task.complete]
      end
    end
  end

end

module TextParser

  def read_text
    File.open(filename).each_line do |line|
      task_info = parse_line(line)
      list.add(Task.new(task_info.description, task_info.complete))
    end
  end

  TaskInfo = Struct.new(:description, :complete)
  def parse_line(line)
    complete = find_completeness(line)
    description = find_description(line)
    TaskInfo.new(description, complete)
  end

  def find_completeness(line)
    if line.match(/\[(.)\]  (.+)/)[1] == "X"
      return true
    else
      return false
    end
  end

  def find_description(line)
    line.match(/\[(.)\]  (.+)/)[2]
  end

  def write_text
    File.open('todo.txt', 'w') do |todo_file|
      list.tasks.each_with_index do |task, index|
        todo_file.puts "#{index + 1}. [#{task.complete ? "X" : " "}]  #{task.description}"
      end
    end
  end

end