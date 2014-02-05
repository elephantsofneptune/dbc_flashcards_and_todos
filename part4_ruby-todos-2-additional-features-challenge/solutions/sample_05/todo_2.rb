require './parse_list'
require './list_view'

class ListController
  VALID_COMMANDS = ["list", "add", "delete", "complete", "quit"]

  def initialize(command, option)
  	@view = ListView.new
  	check_command(command)
  	@command = command
  	@option = option
    @parse_list = ParseList.new("todo.csv")
    @list = @parse_list.todo_list
    command!
  end

  def check_command(command)
    valid_commands unless VALID_COMMANDS.include?(command)
  end

  def valid_commands
    @view.display_valid_commands(VALID_COMMANDS)
  end

  def command!
    case @command
    when "list"
    	display_list
    when "add"
    	add_to_list
    when "complete"
      complete_task
    end
  end

  def display_list
  	@option.empty? ? @view.show_list("to-do list:", @list) : @view.display_tasks(@list, @option)
  end

  def add_to_list
  	task = Task.new({:task => @option.join(" ")})
    # @parse_list.todo_list << task
    @list << task
    p @parse_list
    @parse_list.save_csv
  end

  def complete_task
    @list[@option[0].to_i - 1].complete!
    @parse_list.save_csv
  end
end

def init(command, option)
  ListController.new(command, option)
end

init(ARGV[0], ARGV[1..-1])