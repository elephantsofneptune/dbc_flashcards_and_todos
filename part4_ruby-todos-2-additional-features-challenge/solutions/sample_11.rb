# Solution for Challenge: Ruby Todos 2.0: Additional Features. Started 2013-05-24T00:23:28+00:00
require 'csv'

class List
  attr_accessor :id_numbers, :list

  def initialize(filename)
    @filename = filename
    @list = []
    @id_numbers = (12..1000).to_a 
    import_tasks
  end

  def import_tasks
    CSV.foreach(@filename, :headers => true, :header_converters => :symbol) do |row|
      @list << Tasks.new(row.to_hash)
    end
    save_task
  end

  def add_task(text) 
    @list << Tasks.new({id: @id_numbers.shift, text: text})
    save_task
  end

  def save_task
    CSV.open(@filename, "wb") do |csv| 
      csv << ["id","text","tag","status","completed_at","created_at"]
      @list.each {|list_item| csv << [list_item.id, list_item.text, list_item.tag, list_item.status, list_item.completed_at, list_item.created_at]}
    end
  end

  def to_human!
    CSV.open(@filename, "wb") do |csv| 
      @list.each do |list_item| 
        csv << ["#{list_item.id}. [ ] #{list_item.text}"] if list_item.status == "outstanding"
        csv << ["#{list_item.id}. [X] #{list_item.text}"] if list_item.complete == "complete"
      end
    end
  end

  def delete_task(id)
    @list.delete_if { |task| task.id == id }
    save_task
  end

  def display_all_tasks
    @list.each do |task|
      puts "#{task.id} #{task.text} with taggging #{task.tag} -- #{task.status}"
    end
  end

  def complete_task(id)
    @list.each do |item| 
      item.status = "complete" if item.id.to_i == id
      item.completed if item.id.to_i == id
    end
    save_task
  end

  def display_completed_list
    complete_list = @list.select { |task| task.status == "complete" }
    complete_list.sort_by! {|list_item| list_item.completed_at}
    complete_list.each {|task| p "#{task.id} #{task.text} -- #{task.status}" }
  end

  def display_outstanding
    outstanding_list = @list.select { |task| task.status == "outstanding" }
    outstanding_list.sort_by! {|list_item| list_item.created_at}
    outstanding_list.each {|task| p "#{task.id} #{task.text} -- #{task.status}" }
  end

  def filter_tag(tag)
    tag_list = @list.select { |task| task.tag == tag }
    tag_list.sort_by! {|list_item| list_item.created_at}
    tag_list.each {|task| p "#{task.id} #{task.text} [#{task.tag}] -- #{task.status}" }
  end
  
end


class Tasks

  attr_accessor :status, :completed_at
  attr_reader :id, :text, :tag, :created_at

  def initialize(args)
    @id           = args[:id]   
    @text         = args[:text]
    @tag          = args.fetch(:tag, "personal")
    @created_at   = args.fetch(:created_at, Time.new)
    @status       = args.fetch(:status, "outstanding")
    @completed_at = nil
  end

  def completed
    @completed_at = Time.new
  end

end

list_son = List.new('todo2.csv')

if ARGV.any?
  list_son.add_task(ARGV[1..-1][0]) if ARGV[0] == "add"
  list_son.delete_task(ARGV[1].to_i) if ARGV[0] == "delete"
  list_son.complete_task(ARGV[1].to_i) if ARGV[0] == "complete"
  list_son.to_human! if ARGV[0] == "convert!"
  list_son.display_completed_list if ARGV[0] == "completed"
  list_son.display_outstanding if ARGV[0] == "outstanding"
  list_son.filter_tag(ARGV[1]) if ARGV[0] == "filter"
  # list_son.display_all_tasks
end
