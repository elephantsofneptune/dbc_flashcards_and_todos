require 'csv'
require 'date'

class Task

  attr_accessor :id, :todo, :status, :date, :tag

  def initialize(tasks_info = {})
    @id = tasks_info[:id].to_i
    @todo = tasks_info[:todo]
    @status = tasks_info[:status] || "[ ]"
    @date = tasks_info[:date] || Time.now.strftime("%m/%d/%y")
    @tag = tasks_info[:tag] || ''.upcase
  end

  def to_s
    "#{@status} #{@id} #{@date} #{@todo} #{@tag}"
  end

  def to_a
    [@id,@status,@todo,@date,@tag]
  end
end

class List

  attr_accessor :tasks

  def initialize
    @tasks = []
  end

  def parse_list(list_name)
    CSV.foreach(list_name, :headers => true, :header_converters => :symbol) do |row|
      @tasks << Task.new(row)
    end
    resort
  end

  def resort
    @tasks.each_with_index {|task, index| task.id = index+1 }
  end
  
  def add(task_info)
    @tasks << Task.new(task_info)
    resort
  end

  def get_outstanding
    sorted = @tasks.select { |task| task if task.status == "[ ]" }
    sorted.each_with_index {|task, index| task.id = index+1 }
    by_date = sorted.sort_by { |task| task.date }
    by_date.each {|task| puts "#{task.status} #{task.id} #{task.date} #{task.todo} #{task.tag}" } 
  end

  def complete(list_num)
    @tasks.each { |task| task.status = "[X]" if task.id == list_num }
  end

  def get_completed
    sorted = @tasks.select { |task| task if task.status == "[X]" }
    sorted.each_with_index {|task, index| task.id = index+1 }
    by_date = sorted.sort_by { |task| task.date }
    by_date.each {|task| puts "#{task.status} #{task.id} #{task.date} #{task.todo} #{task.tag}" }
  end

  def delete(list_num)
    @tasks.each { |task| @tasks.delete(task) if task.id == list_num } 
    resort
  end

  def show_todos
    sorted = @tasks.each_with_index {|task, index| task.id = index+1 }
    sorted.each {|task| puts "#{task.status} #{task.id} #{task.date} #{task.todo} #{task.tag}" }
  end

  def list_tag(list_num, clarify)
    @tasks.each {|task| task.tag = clarify.upcase if task.id == list_num }
  end

  def get_tagged
    sorted = @tasks.select { |task| task if task.tag != "" }
    sorted.each_with_index {|task, index| task.id = index+1 }
    by_date = sorted.sort_by { |task| task.date }
    by_date.each {|task| puts "#{task.status} #{task.id} #{task.date} #{task.todo} #{task.tag}" }
  end

  def save_to_csv
    CSV.open('test.csv', 'a+') do |csv|
      @tasks.each do |task|
        csv << task.to_a
      end
    end
  end

  def save_to_text_file
    File.open('test.txt', 'w') do |file|
      @tasks.each do |todo|
        file << todo
      end
    end
  end
end

class View

  @@messages = {
                :saved          => "Saved for another day!",
                :invalid        => "Please enter a valid response.",
                :delete         => "Which todo would you like to delete?",
                :add            => "What do you need to do?",
                :complete       => "Which task would you like to mark as complete?",
                :get_completed  => "Look at all the work you've done!\n\n",
                :get_outstanding=> "You still have a lot to do.\n\n",
                :num_to_tag     => "Which todo do you want to tag?",
                :tag            => "What is your tag?",
                :tagged         => "Here are your tagged todos."
                }

  def welcome
    puts  
    puts "Are you getting your shit done?"
    puts "What would you like to do today?"
    puts
    puts "1 - List all of your todos?"
    puts "2 - List just your outstanding todos?"
    puts "3 - List all your completed todos?"
    puts "4 - Add a task?"
    puts "5 - Tag a task?"
    puts "6 - List tagged tasks?"
    puts "7 - Complete a task?"
    puts "8 - Delete a task?"
    puts "9 - Save all your stuff?"
    puts "10 - Finish?"
    puts
  end

  def prompt(msg)
    puts @@messages[msg]
  end

  def finish
    puts "Goodbye and get to work!\n\n"
    exit
  end

end

class Controller

  def initialize
    @view = View.new
    @list = List.new
  end

  def load_old_list(old_file)
    @list.parse_list(old_file)
  end

  def start!

  @view.welcome

  response = ''

  while true

    system 'stty -echo'
    response = $stdin.gets.chomp.to_i 
    system 'stty echo'

      if response == 1
        puts
        @list.show_todos

      elsif response == 2
        @view.prompt(:get_outstanding)
        @list.get_outstanding

      elsif response == 3
        @view.prompt(:get_completed)
        @list.get_completed       

      elsif response == 4
        @view.prompt(:add) 
        todo = gets.chomp
        @list.add(:todo => todo)

      elsif response == 5
        @view.prompt(:num_to_tag)
        tag_num = gets.chomp.to_i
        @view.prompt(:tag)
        tag = gets.chomp
        @list.list_tag(tag_num, tag)
          
      elsif response == 6
        @view.prompt(:tagged)
        @list.get_tagged
        
      elsif response == 7
        @view.prompt(:complete)
        num = gets.chomp.to_i
        @list.complete(num)

      elsif response == 8
        @view.prompt(:delete) 
        to_delete = gets.chomp.to_i
        @list.delete(to_delete)

      elsif response == 9
        @list.save_to_text_file
        @view.prompt(:saved)

      elsif response == 10
        @view.finish
      else
        @view.prompt(:invalid) 
      end
      start!
    end
  end
end

controller = Controller.new
controller.load_old_list('todo.csv')
controller.start!
    