require 'csv'

$file = 'todo.csv' # A global variable, because I live recklessly!

class List

  def initialize(file)
    if File.exist?(file)
      @new_file = CSV.read(file)
    else
      @new_file = CSV.open(file, "w+") { |new_list| new_list }
    end
  end

  def to_a
    @new_file
  end

end

class Task
  attr_reader :create_task

  def self.create(create_task)
    @create_task = create_task
  end

end

class Parser 

  @@tasks = List.new($file).to_a

  def self.add_numbers_to_todo
    numbers = 1

    @@tasks.each do |add_numbers|
      add_numbers.unshift(numbers.to_s)
      numbers += 1
    end
  end

  def self.add_everything
    if @@tasks[0].length == 1
      add_numbers_to_todo
      add_complete_checks_to_todo
    end
  end

  def self.add_complete_checks_to_todo
    @@tasks.each do |add_checks|
      add_checks.unshift('[ ]')
    end
  end

  def self.add_everything
    if @@tasks[0].length == 1
      add_numbers_to_todo
      add_complete_checks_to_todo
    end
  end

  def self.remove_numbers_or_complete_checks
    @@tasks.each do |remove_numbers|
      remove_numbers.shift
    end
  end

  def self.remove_everything
    if @@tasks[0].length == 3
      remove_numbers_or_complete_checks
      remove_numbers_or_complete_checks
    end
  end

  def self.update_csv
    CSV.open($file, "w") do |added_task|
      @@tasks.each do |task_row|
        added_task << task_row
      end
    end
  end

end

module UIText
  def self.greeting(app)
      "Welcome to the #{app}\nType 'help' for a list of commands"
  end

  def self.help
      puts "HELP"
      puts "-"*50
      puts "new <todo list name>   - Creates a new todo list"
      puts "add <task>             - Adds a task to the list"
      puts "list                   - Lists the todo list"
      puts "delete <task_number>   - Deletes the item at the number in the list"
      puts "complete <task_number> - Marks the item as complete"
      puts "quit                   - Quits the application"
      puts "-"*50
  end
end

class UI < Parser
  include UIText

  def self.run!

    puts UIText.greeting("Todo List Creator")

    print "> "

    @todo = gets.chomp.split(' ')

    @command = @todo.shift.to_sym

    @created_task = Task.create(@todo)

    until @command == :quit

      commands

      puts "running"

      print "> "

      @todo = gets.chomp.split(' ')

      @command = @todo.shift.to_sym

      @created_task = Task.create(@todo)

    end

    commands

  end

  def self.commands

    case @command
    when :add
      new_task = @created_task.join(" ")
      @@tasks << [new_task]
      Parser.remove_everything
      Parser.update_csv
      puts "Added #{new_task} to the list"
    when :list
      if @@tasks.empty?
        puts "Your list is empty."
      else
      puts "Here's the list:"
        Parser.add_everything
        @@tasks.each { |join_tasks_and_checks| puts join_tasks_and_checks.join(" ") }
        Parser.remove_everything
        Parser.update_csv
      end
    when :delete
      @@tasks.delete(@@tasks[@created_task[0].to_i - 1])
      Parser.remove_everything
      Parser.update_csv
      puts "Deleted #{@created_task.join(" ")} from the list"
    when :complete
      Parser.add_everything
      number_to_complete = @created_task[0].to_i - 1
      @@tasks[number_to_complete][0] = "[X]"
      Parser.update_csv
      puts "Completed #{@created_task.join(" ")}"
    when :help
      UIText.help
    when :new
      $file = @created_task
      puts "#{@created_task} created"
    end
  end

end

UI.run!