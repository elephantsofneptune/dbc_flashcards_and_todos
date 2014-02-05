class List
  attr_reader :list_items

  def initialize(list_items = [])
    @list_items = list_items
  end

  def sort_by(param)
    List.new ( list_items.sort_by { |item| item.send(param) } )
  end

  def filter_tags(tag)
    List.new( list_items.find_all { |item| item.has_tag?(tag) } )
  end

  def add_item(item)
    list_items << item
  end

  def find(id)
    list_items.find { |item| item.id == id }
  end

  def remove(id)
    list_items.delete(find(id))
  end

  def completed
    List.new( list_items.find_all(&:completed?) )
  end

  def outstanding
    List.new( list_items.find_all(&:outstanding?) )
  end

  def empty?
    list_items.empty?
  end
end
