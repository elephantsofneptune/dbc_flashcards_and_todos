require 'csv'
require_relative 'ascii_utils.rb'
require_relative 'todo_controller.rb'

class UI
  
  def initialize
    clear_screen!
    move_to_home!
    @l = List.new('todo.csv')
    @l.parse
    home
  end

  def home
    print_line
    puts "my to-dos"
    print_line
    sleep(0.0)
    @l.list
    print_line
    sleep(0.0)
    puts "my options:"
    puts "add 'task' | delete 'id' | change 'id' | list | quit"
    print_line
    menu
  end

  def menu
    print "type here: "
    input = gets.chomp.split(' ')
    case input[0]
    when "add"
      @l.add(input[1..-1].join(' '))
    when "delete"
      @l.delete(input[1].to_i)
    when "change"
      @l.change_status(input[1].to_i)
    when "get list"
      @l.list
    when "quit"
      @l.write
      clear_screen!
      puts "Your list has been saved as:"
      print_line
      @l.list
      print_line
      return
    end
    clear_screen!
    move_to_home!
    puts "....... updating ........"
    sleep(0.5)
    clear_screen!
    move_to_home!
    home
  end
end

UI.new