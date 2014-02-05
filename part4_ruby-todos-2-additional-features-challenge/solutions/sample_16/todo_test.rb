require_relative 'todo'
require 'debugger'


puts "\nCan create a Task object and return argument values."

task_1 = Task.new(:contents => "take out the trash", :status => :incomplete)
p task_1.contents == "take out the trash"
p task_1.status == :incomplete

puts "\nCan update Todo Object status."

task_1.set_status!(:complete)

p task_1.status == :complete


puts "\nCan initialize controller with Model and View objects"

list = Model.new

view = View.new

task = Task

controller = Controller.new(:model => list, :view => view, :data_class => Task)

p controller.model == list
p controller.view == view
p controller.data_class == task


puts "\nModel is initially empty"
p list.tasks == []
p list.size == 0


puts "\nCan add Task objects to Model manually."

list.add_item!(task_1)
p list.tasks.first[1] == task_1
p list.size == 1
p list.tasks.first[0] == 1


puts "\nCan add Task objects through Controller."

task_2 = Task.new(:contents => "start this assignment", :status => :incomplete)
controller.add_item!(task_2)
p list.fetch_item_by_order(2)[1] == task_2
p list.size == 2


puts "\nCan create new Task object through the Controller."
controller.create_item!(:contents => "blow this assignment", :status => :incomplete)
#p list.tasks[1][1].contents == "finish this assignment"
p list.size == 3

puts "\nCan print out a list of tasks."
controller.show_list

puts "\nCan sort the list of tasks by default (alphabetical)"
controller.sort_list!
controller.show_list

puts "\nCan sort the list of tasks by method (:status)"
controller.sort_list!(:status)
controller.show_list

puts "\nCan remove item by list order"
controller.remove_item!(2)
controller.show_list

puts "\nCan remove item by item object id"
controller.remove_item!(1, :object_id)
controller.show_list

puts "\nCan fetch items from a csv file"
controller.fetch_items!('todo.csv')
controller.show_list

puts "\nCan remove items by list ordering"
controller.remove_item!(12)
controller.show_list

puts "\nCan remove items by object id"
controller.remove_item!(1, :object_id)
controller.show_list

puts "\nCan list by completion status"
controller.create_item!(contents: "blah blah blah", status: :complete)
controller.list_by_status(:incomplete)
controller.list_by_status(:complete)

puts "\nCan add tags to tasks"
controller.add_tags!(5, :quick, :interesting)
controller.add_tags!(6, :interesting)
controller.add_tags!(6, :killer)
controller.add_tags!(4, :weak, :boring)
controller.show_list

puts "\nCan filter by tags"
controller.list_by_tag(:interesting)
 