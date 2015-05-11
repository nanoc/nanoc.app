def find_parent(identifier_string)
  parent_glob = identifier_string.sub(%r{/[^/]+\z}, '') + '.*'

  parent = @items[parent_glob]
  if parent
    parent
  elsif parent_glob != '.*'
    find_parent(parent_glob)
  else
    nil
  end
end

def link_back
  parent = find_parent(item.identifier.to_s)
  if parent
    '<p>↑ ' + link_to("Back to #{parent[:short_title] || parent[:title]}", parent) + '</p>'
  else
    ''
  end
end
