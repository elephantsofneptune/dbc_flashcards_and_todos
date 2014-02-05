require 'csv'


class Parser 
  attr_reader :file 
  attr_accessor :list_of_items
  def initialize(file)
    @file = file 
    @list_of_items = []
    @line_at_a_time
  end

  def line_at_a_time 
    CSV.foreach(file) do |row| 
     list_of_items << row 
    end 
    list_of_items
  end  

end 

class To_do_list 
  attr_accessor :document
  def initialize (to_do_list_doc ,new_item = nil )
    @document = to_do_list_doc
  end 
  

  def delete_item(todo_item)
    document.delete_at(todo_item)
    document
  end 

  def add_item(new_item)
    @document = @document << new_item
    @document
  end 
  def complete_task(todo_item)
    p "hi"
    p document
    p todo_item
    document.map!  {|x|  if document[todo_item] == x
            x = "#{document[todo_item].join()}"
            x = "#{x} completed."
            x = x.split(".")
          else 
            x 
         end  }
    p document
  end 
end 

to_do_list_doc = Parser.new('todo.csv').line_at_a_time
list = To_do_list.new(to_do_list_doc)


command = ARGV.shift 
case command
when "add"
  list.add_item(ARGV[0..-1]) 
when "list"
  p list.document
when "delete"
  item = ARGV[0]     
  list.delete_item(item.to_i) 
when "complete" 
  item = ARGV[0]
  list.complete_task(item.to_i)
  puts "you completed this task"
when "new"
p  To_do_list.new(to_do_list_doc)
end 

