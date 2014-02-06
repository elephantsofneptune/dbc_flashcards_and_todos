require 'csv'

module View
  def self.puts_list(data)
    data.each do |item|
      puts "#{item.id}. #{item.completed ? "[X]" : "[ ]"} #{item.task}"
    end
  end

  def self.outstanding(data)
    data.select!{|task| task.completed==false }
    data.sort!{|task1, task2| task1.created_on<=>task2.created_on}
    self.puts_list(data)
  end
  def self.completed(data)
    data.select!{|task| task.completed }
    data.sort!{|task1, task2| task1.completed_on<=>task2.completed_on}
    self.puts_list(data)
  end
  def self.filter(tag, data)
    data.select!{|task| task.has_tag?(tag)}
    data.sort!{|task1, task2| task1.created_on<=>task2.created_on}
    self.puts_list(data)
  end
end

class ListController
  def initialize(filename)
    File.new("todo.csv", "a+") unless File.exist?("todo.csv")
    @file="todo.csv"
    @list = []
    parse_list
  end

  def control
    begin
      if ARGV[0][0..3]=='list'
        list
      elsif ARGV[0][0..5]=='filter'
        filter
      elsif ARGV[0]=='tag'
        tag(ARGV[1], ARGV[2..-1])
      else
        self.send(ARGV[0], ARGV[1..-1])
      end
     rescue NoMethodError
       puts "Not a valid command."
    end
  end

  def add(item)
    @list << Task.new({task: item.join(" "), completed: false})
    save_list
  end

  def delete(index)
    index=index.first.to_i-1
    puts "Deleted \"#{@list[index].task}\""
    @list.delete_at(index)
    save_list
  end

  def complete(index)
    index=index.first.to_i
    @list[index-1].complete
    save_list
  end

  def tag(index, terms)
    terms.each do |term|
      @list[index.to_i-1].tag(term)
    end
    save_list
  end


  def filter
    term=ARGV[0][7..-1]
    View.filter(term, @list)
  end

  def list
    if ARGV[0]=="list"
      View.puts_list(@list)
    elsif ARGV[0].include?("outstanding")
      View.outstanding(@list)
    elsif ARGV[0].include?("completed")
      View.completed(@list)
    end
  end

  private
  def parse_list
    CSV.foreach("todo.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      @list << Task.new(row)
    end
  end

  def save_list
    headers = [:id, :created_on, :task, :completed, :completed_on, :tags]
    CSV.open("todo.csv", 'wb') do |file|
      file << headers
      @list.each do |task|
        file << task.to_a
      end
    end
  end
end

class Task
  attr_reader :id, :task, :created_on, :completed_on, :completed, :tags
  @@id=1
  def initialize(args)
    @task = args[:task]
    @completed = args[:completed]=="true"
    @id=@@id
    @@id+=1
    @completed_on = args[:completed_on]
    @created_on = args[:created_on] ? args[:created_on] : Time.new.to_s
    @tags = args[:tags] ? args[:tags].split : []


  end

  def complete
    @completed=true
    @completed_on=Time.new.to_s
    puts "Completed \"#{@task}\""
  end

  def has_tag?(tag)
    @tags.include?(tag)
  end

  def tag(term)
    @tags << term unless @tags.include?(term)
    puts "Tagged \"#{@task}\" with #{term}"
  end

  def to_a
    [@id, @created_on, @task, @completed, @completed_on, @tags.join(' ')]
  end
end



list=ListController.new("todo.csv")
list.control
