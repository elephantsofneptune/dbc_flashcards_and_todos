require 'date'

class ListItem
 attr_reader :id, :task, :status, :created_at, :tags

  def initialize(args)
    @id          = args[:id]
    @task        = args[:task]
    @status      = args[:status]
    @tags        = args[:tags] || []
    @created_at  = created_at_time(args[:created_at])
  end

  def completed!
    @status = :complete
  end

  def completed?
    status == :complete
  end

  def outstanding?
    status == :incomplete
  end

  def tags_string
    tags.join(", ")
  end

  def tags?
    !tags.empty?
  end

  def add_tags(new_tags)
    new_tags.each do |new_tag|
      tags << new_tag unless tags.include?(new_tag)
    end
  end

  def remove_tags(new_tags)
    tags.delete_if { |tag| new_tags.include?(tag) }
  end

  def has_tag?(tag)
    tags.include?(tag)
  end

  private
  def created_at_time(created_at)
    if created_at
      DateTime.parse(created_at)
    else
      Time.now
    end
  end
end