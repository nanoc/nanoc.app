def link_back(parent_identifier=@item.identifier.parent)
  return '' if parent_identifier.to_s == '/'

  parent = @items[parent_identifier + '.*']
  return link_back(parent_identifier.parent) if parent.nil?

  '<p>↑ ' + link_to("Back to #{parent[:short_title] || parent[:title]}", parent) + '</p>'
end
