# Solution for Challenge: Ruby Todos 2.0: Additional Features. Started 2013-03-25T23:25:06+00:00

require 'csv'

class List
  attr_accessor :task_list, :file_name

  def initialize(file_name)
    @file_name = file_name
    @task_list = List.parse_csv(file_name)
  end

  def self.parse_csv(file_name)
    task_list_hash = {}
    task_id = 1
    CSV.foreach(file_name, 'r') do |row|
      task_list_hash[task_id] = Task.new(task_id, row[1], row[2], row[3], row[4])
      task_id += 1
    end
    task_list_hash
  end

  def add_task(description)
    self.task_list[task_list.length+1] = Task.new(task_list.length+1, description, 'Incomplete', Time.new.asctime)
    self.task_list
    save!
  end

  def delete_task(task_id)
    self.task_list.delete(task_id)
    save!
  end

  def complete_task(task_id)
    self.task_list[task_id].time = Time.now.asctime
    self.task_list[task_id].status = "Complete"
    save!
  end

  def display_tasks
    self.task_list.each_value {|task| puts "#{task.id} -- #{task.description} -- #{task.status} -- #{task.time} Tags: #{task.tags}"}
  end

  def add_tags(id, tag_info)
    self.task_list[id].tags = tag_info.join(' ')
    save!
  end

  def save!
    CSV.open(file_name, 'wb') do |csv_obj|
      self.task_list.each_value do |task|
        csv_obj << [task.id, task.description, task.status, task.time, task.tags]
      end
    end
  end

end


class Task
  attr_accessor :id, :description, :status, :time, :tags
  def initialize(id, description, status, time, tags = '')
    @id = id
    @description = description
    @status = status
    @time = time
    @tags = tags
  end



end

class Interface
  def self.load(action, task_info, list_obj, tag_index)
    puts "Welcome to your To-do list!"
    puts "Commands: list, add, delete, complete, list:outstanding, list:completed, tag"
    case
    when action == 'list'
      list_obj.display_tasks
    when action == 'add'
      list_obj.add_task(task_info)
      list_obj.display_tasks      
    when action == 'delete'
      list_obj.delete_task(task_info.to_i)
      list_obj.display_tasks
    when action == 'complete'
      list_obj.complete_task(task_info.to_i)
      list_obj.display_tasks
    when action == 'list:outstanding'
      outstanding_tasks = list_obj.task_list.reject! {|key, task| task.status == "Complete"}
      outstanding = outstanding_tasks.sort_by {|key, value| value.time}.reverse!
      outstanding.each {|task| puts "#{task[1].id} -- #{task[1].description} -- #{task[1].status} -- #{task[1].time} Tags: #{task.tags}"}
    when action == 'list:completed'
      outstanding_tasks = list_obj.task_list.reject! {|key, task| task.status == "Incomplete"}
      outstanding = outstanding_tasks.sort_by {|key, value| value.time}.reverse!
      outstanding.each {|task| puts "#{task[1].id} -- #{task[1].description} -- #{task[1].status} -- #{task[1].time} Tags: #{task.tags}"}
    when action == 'tag'
      list_obj.add_tags(tag_index.to_i, task_info)
      list_obj.display_tasks
    end

  end
end



list = List.new('todo2.csv')
task_action = ARGV[0]
if ARGV[0] == 'tag'
  tag_index = ARGV[1]
  task_info = ARGV[2..-1]
else
  task_info = ARGV[1..-1].join(' ')
end

# list.add_tags(1, ['test'])
# p list.task_list.each_value {|task| p task.tags}

Interface.load(task_action, task_info, list, tag_index)
