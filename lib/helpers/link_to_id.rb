def link_to_id(id)
  item = @items.find { |i| i.identifier == id }
  link_to(item[:title], item)
end
