require 'csv'

class Task

  attr_accessor :status, :text, :id

  def initialize(args)
    @text = args[:text]
    @status = args[:status]
  end

  def to_s
    "#{text}. [#{status}]"
  end

end

class List

  attr_accessor :tasks

  def initialize(file)
    @file = file
    @tasks = []
  end

  def parse
    # return @tasks if @tasks
    CSV.foreach(@file) do |csv|
      @tasks << Task.new(:text => csv[0], :status => csv[1])
    end
  end
  
  def add(task)
    @tasks << Task.new(:text => task)
  end
  
  def list
    @tasks.each_with_index {|t, i| puts "#{i + 1}. #{t}" }
  end

  def change_status(id)
    t = @tasks.each_with_index.find { |t, i| i == id - 1 }[0]
    t.status == "not done" ? t.status = "done" : t.status = "not done"
  end

  def delete(id)
    @tasks.delete_at(@tasks.each_with_index.find { |t, i| i == id - 1 }[1])
  end

  def write(new_file = @file)
    CSV.open(@file, "wb") do |csv|
      @tasks.each do |task| 
        csv << [task.text, task.status] # need to change
      end
    end
  end

end
