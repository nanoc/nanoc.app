# encoding: utf-8

def nav_link(item)
  link_to_unless_current(item[:nav_title] || item[:title], item)
end

def nav_home_link
  if @item.identifier == '/'
    '<span class="active"><span>Home</span></span>'
  else
    '<a href="/"><span>Home</span></a>'
  end
end
