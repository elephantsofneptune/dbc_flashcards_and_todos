require 'csv'

class Task

  ATTRIBUTES = %w{ id status text tags}

  attr_accessor :id, :status, :text, :tags

  def initialize(attrs={})
    @id     = attrs[:id]
    @status = attrs[:status]
    @text   = attrs[:text]
    @tags   = attrs[:tags].nil? ? [] : attrs[:tags].split
  end

  def attributes
    [id, status, text, tags.join(' ')]
  end

end

class List
  COMPLETED   = 'X'
  UNFINISHED  = '_'

  attr_accessor :agenda

  def initialize
    @agenda = []
  end

  def tasks(list = self.agenda)
    list.each do |task|
      puts "%s [#{task.status}]\t#{task.text} [#{task.tags.join ']['}]" % [(task.id.to_s + '.').ljust(3)]
    end
  end

  def add(input)
    task = { id:     self.agenda.size + 1,
             status: UNFINISHED,
             text:   input }
    self.agenda << Task.new(task)
  end

  def update_id
    self.agenda.each_with_index { |task, task_id| task.id = task_id + 1 }
  end

  def add_tag_by_id(id, *tags)
    self.agenda.each { |task| task.tags << tags if task.id == id }
  end

  def make_tags_unique
    # IMPLEMENT LATER
  end

  def delete_by_id(id)
    self.agenda.reject! { |task| task.id == id }
    update_id
  end

  def complete_by_id(id)
    self.agenda.each { |task| task.status = COMPLETED if task.id == id }
  end

  def display_selected(status)
    tasks( self.agenda.select { |task| task.status == status } )
  end

  def display_by_filter(tag)
    tasks( self.agenda.select { |task| task.tags.include?(tag) } )
  end
end

class Parser
  @@result = List.new

  def self.read_data_to_list(filename)
    CSV.foreach(filename, {:headers => true, :quote_char => "|", :header_converters => :symbol}) do |task|
      @@result.agenda << Task.new(task)
    end

    @@result
  end

  def self.save(filename)
    CSV.open(filename, 'wb', :quote_char => "|") do |file|
      file << Task::ATTRIBUTES

      @@result.agenda.each do |task|
        file << task.attributes
      end
    end
  end
end

class ToDoUI
  FILE = 'blah.csv'
  @@list = Parser.read_data_to_list(FILE)

  def self.is_empty?
    ARGV[1..-1].empty? == false
  end

  def self.is_int?
    ARGV[1].to_i > 0
  end

  def self.add(id)
    @@list.add(id)
  end

  def self.delete(id)
    @@list.delete_by_id(id)
  end

  def self.complete(id)
    @@list.complete_by_id(id)
  end

  def self.task
    ARGV[1..-1].join ' '
  end

  def self.add_tags(id)
    @@list.add_tag_by_id(id, ARGV[2..-1])
  end

  def self.filter(tag)
    @@list.display_by_filter(tag)
  end

  def self.error
    raise "INVALID INPUT!"
  end

  def self.run
    if ARGV.any?

      case ARGV[0]
      when "add"      then self.is_empty? ? self.add(self.task)   : self.error
      when "list"     then @@list.tasks
      when "delete"   then self.is_int? ? self.delete(ARGV[1])    : self.error
      when "complete" then self.is_int? ? self.complete(ARGV[1])  : self.error
      when "list:completed"   then @@list.display_selected(List::COMPLETED)
      when "list:outstanding" then @@list.display_selected(List::UNFINISHED)
      when "tag"      then self.add_tags(ARGV[1])
      when "filter"   then self.filter(ARGV[1])
      else self.error
      end

      Parser.save(FILE)
    else
      puts "Please enter the following command:"
      puts "list"
      puts "list:completed"  
      puts "list:outstanding"  
      puts "add task"
      puts "delete <task_id>"
      puts "complete <task_id>"
    end
  end
end

ToDoUI.run