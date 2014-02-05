# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

require 'csv'

class Todo
  attr_reader :status, :description

  def initialize(description)
    @description = description
    @status = :incomplete 
  end

  def mark_complete
    @status = :complete 
  end

  def to_s
    @description
  end
end


class List
  attr_reader :items
  def initialize(csv_file = nil)  
    @items = []
    insert_csv_rows_in_list_as_todos(csv_file) if csv_file
    @save_file = csv_file || nil
  end    

  def insert_csv_rows_in_list_as_todos(csv_file)
    CSV.foreach(csv_file) do |row| # make todo.csv passed in from arguement
      @items << Todo.new(row.join)
    end
  end

  def add_item(description)
    @items << Todo.new(description)
  end

  def delete_item(item_num)
    @items.slice!(item_num)
  end

  def list_items
    @items
  end

  def save(filename = nil)
    @save_file = filename if filename
    CSV.open(@save_file, "wb") do |csv|
      @items.each do |item|
        # p row.class
        # p csv.class
         csv << [item.description]
      end
    end
  end

end

class TodoApp
  def initialize(list)
    @list = list
  end

  def display_list
    puts "Todo List"
    puts "-"*40
    # display = @list.items.each_with_index do |item, index|
    @list.items.each_with_index do |item, index|
              puts   "#{index + 1} :  #{item }"
      end
    puts "-"*40
  end

  def add(todo)
    @list.add_item(todo)
    @list.save
    puts "Added todo #{@list.items.size} : #{todo}"
  end

  def delete(todo_num)
    # deleted_item = @list.items.slice!((todo_num -1))
    deleted_item = @list.delete_item(todo_num -1)
    puts "Deleted todo #{todo_num} : #{deleted_item}"
    @list.save
  end
end



def assert(expression, expression_string = nil)  
  raise "Test failed : #{expression_string}" unless expression
end

# todo1 = Todo.new("walk the dog")
# list1 = List.new
# list1.add_item("pick up milk")
# list1.add_item("go to store")
# list1.add_item("call home!")
# list1.add_item("feed cat!")
# list1.delete_item(1)
# list1.list_items
# todo2 = Todo.new("eat lunch")
# assert(todo2.status == :incomplete, "todo2.status == :incomplete")
# assert(todo2.mark_complete == :complete, "todo2.mark_complete == :complete")
# assert(todo2.status == :complete, "todo2.status == :complete")
# list1.list_items
# list1.save('test_save2.csv')
# assert(list3 = List.new('todo.csv'))
# assert(list3.add_item("jump in the lake"))
# assert(list3.save)



# # todo_app1 = TodoApp.new(list3)
# list4 = List.new(ARGV[0])

# # todo_app1 = TodoApp.new(ARGV)
# todo_app1 = TodoApp.new(list4)
# todo_app1.add("walk on the moon")
# todo_app1.display_list
# todo_app1.delete(6)
# todo_app1.display_list

list5 = List.new('todo.csv')
app = TodoApp.new(list5)
case ARGV[0]
when "list"
  app.display_list
when "add"
  app.add(ARGV[1..-1].join(' '))
when "delete"
  app.delete(ARGV[1].to_i)
end


