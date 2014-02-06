require 'csv'
require 'date'


class CSVParser
  def self.load
    test = []
    CSV.foreach('todo3.csv', { headers: true, header_converters: :symbol }) do |row|
      test << Task.new(row.to_hash)
    end

    test
  end
end


class Task
  attr_reader :todo, :index, :completion_date, :creation_date, :tags
  attr_accessor :status

  def initialize(args)
    @index = args[:index]
    @status = args[:status]
    @todo = args[:todo]
    @creation_date = args[:creation_date]
    @completion_date = args[:completion_date]
    @tags = args[:tags]
  end

  def complete!
    @status = 'complete'
    @completion_date = Date.today.to_s
  end

  def tag!(tags)
    @tags = tags
  end

  def incomplete?
    status == 'incomplete'
  end
  
  def completed?
    status == 'complete'
  end

  def to_a
    [@index, @status, @todo, @creation_date, @completion_date, @tags]
  end
end

module Output
  def welcome
    puts "Your Todo List"
    puts "========================================================================"
  end 

  def clear_screen
    print "\e[2J"
    print "\e[H"
  end
end

class TodoList
  attr_reader :list

  def initialize(args)
    @list = args
  end

  def save
    CSV.open('todo3.csv', "w") do |csv|
      csv << ['index', 'status', 'todo', 'creation_date', 'completion_date', 'tags']
      list.each { |todo| csv << todo.to_a }
    end
  end

  def convert_to_hash(task)
    {:index => list.last.index.to_i+1, :status => 'incomplete', :todo => task, :creation_date => Date.today.to_s, :completion_date => nil, :tags => nil}
  end

  def display
    list
  end

  def add(task) 
    @list << Task.new(convert_to_hash(task))
    save
  end

  def find_at(index)
    task = list.find do |task|
      task.index == index.to_s
    end
    task
  end

  def delete_at(index)
    puts "deleting at #{index}"
    list.delete(find_at(index))
    save
  end

  def created_first
    list.sort_by do |task|
      task.creation_date
    end
  end

  def outstanding #Add formatting when outputting
    created_first.select do |task|
      task.incomplete?
    end
  end

  def completed_first
    list.select { |task| task.completion_date != nil }.sort_by do |task|
      task.completion_date
    end.reverse
  end

  def completed
    completed_first.select do |task|
      task.completed?
    end
  end

  def complete_at(index)
    find_at(index).complete!
    save
  end

  def tag(index, tags)
    find_at(index).tag!(tags)
    save
  end

  def filter(tag) 
    list.select { |task| task.tags.include?(tag) }
  end 
end


class UI 
  include Output

  attr_reader :command, :argument, :tags, :list

  def initialize
    @list = TodoList.new(CSVParser.load)
  end

  def x_bracket(task)
    task.completed? ? '[X]' : '[ ]'
  end

  def pretty_print(array)
    array.each do |task|
      puts "#{task.index}. #{x_bracket(task)} #{task.todo} - Completed: #{task.completion_date} - Created: #{task.creation_date} - Tags: #{task.tags}"  
    end
  end

  def start(input)
    clear_screen
    welcome
    parse_input(input)

    case command
    when "list" 
      if argument == "outstanding"
        pretty_print(list.outstanding)
      elsif argument == "completed"
        pretty_print(list.completed)
      else
        pretty_print(list.display)
      end
    when "add"
      list.add(argument)
      pretty_print(list.display)
    when "delete"
      list.delete_at(argument)
      pretty_print(list.display)  
    when "complete"
      list.complete_at(argument)
      pretty_print(list.display)
    when "filter"
      pretty_print(list.filter(argument))
    when "tag"
      list.tag(argument, tags)
      pretty_print(list.display)
    end
  end

  def parse_input(input)
    if input[0].include?(':')
      @command = input[0].split(':')[0]
      @argument = input[0].split(':')[1]
    elsif input[0].include?('add')
      @command = ARGV.shift
      @argument = ARGV.join(" ").chomp
    else
      @command = ARGV.shift
      @argument = ARGV.shift
      @tags = ARGV.join(" ")
    end
  end
end


app = UI.new
app.start(ARGV)

