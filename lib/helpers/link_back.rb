def link_back
  parent = breadcrumbs_trail[0..-2].compact.last
  return '' if parent.nil? # FIXME
  return '' if parent.identifier == '/'

  '<p>↑ ' + link_to("Back to #{parent[:short_title] || parent[:title]}", parent) + '</p>'
end
