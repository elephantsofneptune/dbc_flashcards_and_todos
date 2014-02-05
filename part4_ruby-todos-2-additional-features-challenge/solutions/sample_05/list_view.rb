class ListView
  def display_tasks(list, option)
    case option[0]
  	when "outstanding"
  		show_list("outstanding to-dos:", outstanding(list))
  	when "completed"
  		show_list("completed to-dos:", completed(list))
  	when "tag"
  		show_list("list by tag:", tag(list, option))
  	end
  end

  def show_list(header, list)
    puts "    | #{header}".upcase
    list.each_with_index do |task, index|
      puts "#{task.display_status} | #{index + 1}. #{task.task} (#{task.date}) ##{task.tag}"
    end
  end

  def completed(list)
    list.select { |task| task.status == "complete" }
  end

  def outstanding(list)
    list.select { |task| task.status == "pending" }
  end

  def tag(list, option)
    list.select { |task| option.include?(task.tag) }
  end

  def display_valid_commands(valid_commands)
    puts "Valid Commands: #{valid_commands.join(", ")}"
  end
end