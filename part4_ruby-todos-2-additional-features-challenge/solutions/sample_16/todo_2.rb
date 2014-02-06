# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).



class Controller

  attr_reader :view, :model, :data_class

  def initialize(args)

    @view = args[:view] || raise("ArgumentError: view argument required")
    @model = args[:model] || raise("ArgumentError: model argument required")
    @data_class = args[:data_class] || raise("ArgumentError: data_class argument required")

  end

  def run!
    show_list
    input = get_input
    print_results(input)
  end

  def show_list (item_list = standard_output, title_option = nil)
    output = "Your #{title_option}Tasks:\n"
    counter = 1
    item_list.each do |object_id, object|
      counter_str = "#{counter}."
      tags = "tags: #{object.tags}" unless object.tags.empty?
      output << "#{counter_str.ljust(4)} #{object.contents.ljust(60)} [#{object.status}] [object_id: #{object_id}] #{tags}\n"
      counter += 1
    end
    view.render(output)
  end

  def standard_output
    self.model.tasks
  end

  def sort_list!(sorting_method = :contents)
    self.model.sort_list!(sorting_method)
  end

  def create_item!(args)
    new_item = self.data_class.new(args)
    add_item!(new_item)
  end

  def add_item!(new_item)
    model.add_item!(new_item)
    output = "Appended '#{new_item.contents}' to your TODO list...\n"
    view.render(output)
  end

  def fetch_items!(filename)

    items = File.open(filename).each do |line|
      contents = line.strip
      new_item = self.data_class.new(:contents => contents)
      self.model.add_item!(new_item)
    end
  end

  def update_item_contents!(item, new_contents)
    item.contents = new_contents
  end

  def remove_item!(number, object_id_flag = false)
    model.remove_item!(number: number, object_id_flag: object_id_flag)
  end

  def set_status!(number, new_status, object_id_flag = false)
    model.set_status!(number: number,
                      new_status: new_status, 
                      object_id_flag: object_id_flag)
  end

  def list_by_status(status)
    list = model.tasks.select{|id, object| object.status == status}
    show_list(list, status.to_s.capitalize + " ")
  end

  def list_by_tag(tag)
    list = model.tasks.select{|id, object| object.tags.include?(tag)}
    show_list(list)
  end

  def add_tags!(object_id, *tags)
    task = model.fetch_item_by_id(object_id)
    task[1].add_tags!(tags)
  end

end

class View

  def initialize
  end

  def render(output)
    print output
  end

end

class Model

  @@next_id = 1 

  attr_accessor :tasks

  def initialize
    @tasks = []
  end

  def add_item!(item)
    self.tasks << [@@next_id, item]
    increment_next_id 
  end

  def increment_next_id
    @@next_id += 1
  end

  def fetch_item_by_id(item_id)
    self.tasks.find {|id,item| id == item_id }
  end

  def fetch_item_by_order(item_position)
    self.tasks[item_position-1]
  end

  def sort_list!(sorting_method)

    sorted_tasks = self.tasks.sort_by do |object_id, object| 
        object.send(sorting_method)
    end
    self.tasks = sorted_tasks
  end

  def size
    self.tasks.size
  end

  def nth_item(n)
    self.tasks[n]
  end

  def set_status!(args)
    status = args[:new_status]
    number = args[:number]
    object_id_flag = args[:object_id_flag]

    if object_id_flag
      set_status_by_object_id!(number, status)
    else
      set_status_by_list_order!(number, status)
    end
  end

  def set_status_by_object_id!(object_id, status)
    object = self.tasks.find { |id, object| id == object_id}
    object.status = status
  end

  def set_status_by_list_order!(listing_number, status)
    self.tasks[listing_number.to_i-1][1].status = status
  end

  def remove_item!(args)

    number = args[:number]
    object_id_flag = args[:object_id_flag]

    if object_id_flag

      remove_item_by_object_id!(number)
    else
      remove_item_by_list_order!(number)
    end
  end

  def remove_item_by_object_id!(object_id)
    self.tasks.delete_if { |id, object| id == object_id}
  end

  def remove_item_by_list_order!(listing_number)
    self.tasks.delete_at(listing_number-1)
  end

  def statuses
    remaining_statuses = self.tasks.map do |object_id, object|
      object.status
    end
    remaining_statuses.uniq!
  end

end


class Task

  attr_accessor :contents, :status, :tags

  attr_reader :created_at

  def initialize(args)
    @contents = args.fetch(:contents) { raise("ArgumentError: content argument required")}
    @status = args.fetch(:status) {:incomplete}
    @tags = args.fetch(:tags) {[]}
    @created_at = Time.now
  end

  def set_status!(status)
    self.status = status
  end

  def add_tags!(tags)
    tags.each do |tag|
      self.tags << tag
    end
    self.tags.sort!.uniq!
  end

end

def to_boolean(str)
  str == 'true'
end

if ARGV.any?

  list = Model.new
  view = View.new
  controller = Controller.new(:model => list, :view => view, :data_class => Task)

  controller.fetch_items!("todo.csv")

  command = ARGV[0]
  arguments = ARGV[1..-1]
  controller.create_item!(contents: "submiteed this assignment", status: :complete)
  controller.add_tags!(5, :quick, :interesting)
  controller.add_tags!(6, :interesting)
  controller.add_tags!(6, :killer)
  controller.add_tags!(4, :weak, :boring)
  
  # debugger

  case 

  when command == "show_list"
    controller.show_list
  when command == "list:outstanding"
    controller.list_by_status(:incomplete)
  when command == "list:completed"
    controller.list_by_status(:complete)
  when command == "sort_list!" && arguments
    if arguments.empty? 
      controller.sort_list! 
    else
      status = arguments[0] 
      status = status[1..-1]
      controller.sort_list!(status.to_sym)
    end
    controller.show_list
  when command == "filter:" && arguments
    tag = arguments[0]
    tag = tag[1..-1]
    controller.list_by_tag(tag.to_sym)
  when command == "tag" && arguments
    task_id = arguments.shift.to_i
    task_id
    arguments.map! {|arg| arg[1..-1].to_sym}
    controller.add_tags!(task_id, *arguments)
    controller.show_list
  when command == "add_item" && arguments
    controller.add_item!(arguments.first)
  when command == "remove_item!" && arguments
    number, object_id_flag = *arguments
    controller.remove_item!(number.to_i, to_boolean(object_id_flag))
    controller.show_list
  when command == "set_status" && arguments
    number, status = *arguments 
    status = status[1..-1]
    controller.set_status!(number, status.to_sym)
    controller.show_list
  else
    puts "please enter valid command"
  end
end


