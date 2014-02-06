require './list_item'
require './user_interface'
require './database'

class MiddleMan
  attr_reader :id, :action, :task, :database, :user_interface, :tags

  def initialize(args)
    @id             = args[:id]
    @action         = args[:action]
    @task           = args[:task]
    @tags           = args[:tags]
    @database       = Database.new('todo.txt')
    @user_interface = UserInterface.new
    execute!
  end

  def execute!
    if self.respond_to?(action)
      if self.send(action)
        database.save
      else
        user_interface.invalid_id
      end
    else
      user_interface.non_action
    end
  end

  def default_task_args
    {:id => id, :task => task, :status => :incomplete,
     :created_at => Time.now, :tags => tags}
  end

  def add
    database.add_item(ListItem.new(default_task_args))
    user_interface.confirm_add(task)
    true
  end

  def list
    user_interface.display_list(database.get_list)
  end

  def list_completed
    list = database.get_list(:completed)
    user_interface.display_list(list, :created_at)
  end

  def list_outstanding
    list = database.get_list(:outstanding)
    user_interface.display_list(list, :created_at)
  end

  def delete
    item = database.get_item(id)
    return false if item.nil?

    database.delete(item.id)
    user_interface.confirm_delete(item)
    true
  end

  def complete
    item = database.get_item(id)
    return false if item.nil?

    database.complete_item(item.id)
    user_interface.confirm_complete(item)
    true
  end

  def tag
    item = database.get_item(id)
    return false if item.nil?

    database.add_tags(item.id, tags)
    user_interface.confirm_tag(item, tags)
    true
  end

  def remove_tag
    item = database.get_item(id)
    return false if item.nil?

    database.remove_tags(item.id, tags)
    user_interface.remove_tag(item, tags)
    true
  end

  def filter_tag
    list = database.filter_tags(tags)
    user_interface.display_list(list, :created_at)
  end
end