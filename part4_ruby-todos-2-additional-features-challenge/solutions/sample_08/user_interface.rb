class UserInterface
  COMPLETION = {:complete => "[X]", :incomplete => "[ ]"}

  def display_list(list, order = nil)
    puts "The list is empty" if list.empty?
    list = list.sort_by(order) if order
    list.list_items.each do |item|
      str = "#{item.id}.".ljust(4) + " #{COMPLETION[item.status]} #{item.task}"
      str << " - Tags: #{item.tags_string}" if item.tags?
      puts str
    end
  end

  def confirm_add(item)
    puts "Appended #{item.task} to your TODO list..."
  end

  def confirm_delete(item)
    puts "Deleted #{item.task} from your TODO list..."
  end

  def confirm_complete(item)
    puts "#{item.task} has been marked as complete!"
  end

  def confirm_tag(item, tags)
    puts "Tagging task #{item.task} with tags: #{tags.join(", ")}"
  end

  def remove_tag(item, tags)
    puts "Removing tags: #{tags.join(", ")} from task: #{item.task}"
  end

  def non_action
    puts "Command not recognized."
  end

  def invalid_id
    puts "Invalid id."
  end
end
