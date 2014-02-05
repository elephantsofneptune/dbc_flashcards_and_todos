require './todo_parser'
require './list'
require './list_item'

class Database
  COMPLETION = {:complete => "[X]", :incomplete => "[ ]"}
  attr_reader :parser, :file, :list

  def initialize(file)
    @file   = file
    @parser = TodoParser
    @list   = create_list
  end

  def add_item(list_item)
    list.add_item(list_item)
  end

  def get_list(param = nil)
    param ? list.send(param) : list
  end

  def filter_tags(tag)
    list.filter_tags(tag)
  end

  def get_item(id)
    list.find(id)
  end

  def create_list
    list = List.new
    parser.each_entry(file) do |item_data|
      item_data.merge!(:status => set_status(item_data),
                       :tags => set_tags(item_data))
      list.add_item(ListItem.new(item_data))
    end
    list
  end

  def delete(id)
    list.remove(id)
  end

  def complete_item(id)
    item = list.find(id)
    item.completed!
  end

  def add_tags(id, tags)
    get_item(id).add_tags(tags)
  end

  def remove_tags(id, tags)
    get_item(id).remove_tags(tags)
  end

  def save
    File.open(file, "w") do |file|
      list.list_items.each_with_index do |item, idx|
        data = ""
        data << "#{idx + 1}. #{COMPLETION[item.status]} "
        data << "[#{format_time(item.created_at)}]"
        data << " [#{item.tags_string}] " if item.tags?
        data << "#{item.task}\n"
        file.write(data)
      end
    end
  end

  private
  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  def set_status(item_data)
    COMPLETION.key(item_data[:status])
  end

  def set_tags(item_data)
    if item_data[:tags].nil?
      []
    else
      item_data[:tags].gsub(/([\[])(.*)([\]])/, "\\2").strip.split(", ")
    end
  end
end
