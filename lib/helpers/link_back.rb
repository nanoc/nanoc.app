def link_back
  # FIXME
  return '<p>???</p>'

  parent = breadcrumbs_trail[0..-2].compact.last
  return '' if parent.identifier == '/'

  '<p>↑ ' + link_to("Back to #{parent[:short_title] || parent[:title]}", parent) + '</p>'
end
