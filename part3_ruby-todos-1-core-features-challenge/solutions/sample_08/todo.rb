require 'csv'

class ToDoParser
  attr_reader :list

  def initialize(file)
    @file = file
    @list = nil
  end

  def make_list
    return @list if @list
    @list = []

    CSV.foreach(@file, :quote_char => "\x00") do |row|
      unless list[0] == "text"
        @list << ToDo.new(row[0], row[1])
      end
    end
  end

  def save
    CSV.open(@file, "wb", :quote_char => "\x00") do |csv|
      @list.each { |note| csv << [note.text, note.completed_status] unless note.text == "text" }
    end
  end

  def view_list
    @list.each_with_index do |note, i| 
      puts "#{note.completed_status} #{i+1}. #{note.text}" unless note.completed_status == nil 
    end
  end

  def add_note(text)
    text = text
    @completed_status ||= "[ ]"

    @list << ToDo.new(text, @completed_status)
  end

  def mark_complete(index)
    @list[index-1].completed_status = "[X]"
  end

  def delete(index)
    @list.delete_at(index)
    @list
  end
end

class ToDo
  attr_reader :text
  attr_accessor :completed_status

  def initialize(text, completed_status)
    @text = text
    @completed_status = completed_status
  end

  def to_s
    "#{text} #{completed_status}"
  end
end

model = ToDoParser.new("todo_copy.csv")
model.make_list
# model.save
# model.add_note("Go to the movies")
# model.add_note("Hello")
# model.add_note("text")
# model.mark_complete(3)
# model.save
# model.view_list

if $ARGV.any?
  
  if $ARGV[0] == "list"
    model.view_list

  elsif $ARGV[0] == "add"
    note = ToDo.new($ARGV[1..-1].join(" "),nil)
    model.add_note(note)
    puts "Adding your note: #{$ARGV[1..-1].join(" ")}"
    model.save

  elsif $ARGV[0] == "delete"
    puts "What choice would you like to delete?"
    choice = $stdin.gets.chomp
    model.delete_note(choice.to_i)
    model.save
    model.view_list

  elsif $ARGV[0] == "new"
    puts "Generating an fresh list for you..."
    puts "Type todo.rb 'add' to add a new item."
    model.make_new_list
    model.save

  elsif $ARGV[0] == "complete"
    puts "Which item would you like to mark completed?"
    choice = $stdin.gets.chomp
    model.mark_complete(choice.to_i)
    model.save
    model.view_list
  else
    puts "Sorry, I didn't recognize that command."
  end
end