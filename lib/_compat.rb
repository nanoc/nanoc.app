def new_item(content, attributes, identifier, params = {})
  Nanoc::Item.new(content, attributes, identifier, params)
end

Nanoc::Int = Nanoc
