def seq_nav_links
  return nil unless @item.identifier =~ '/doc/**/*'

  root = @items['/doc.*']

  globs = root[:toc].flat_map { |t| t[:children] }
  ordered_items = globs.map { |g| @items[g] }

  index = ordered_items.find_index { |i| i == @item }

  s = ''

  prev_item = index && index > 0 ? ordered_items[index-1] : nil
  if prev_item
    s << '<span class="seq-nav-link">'
    s << link_to('← prev', prev_item, title: prev_item[:title])
    s << '</span>'
  else
    s << '<span class="seq-nav-link disabled">← prev</span>'
  end

  s << '<span class="seq-nav-link">'
  s << link_to('up', root, title: root[:title])
  s << '</span>'

  next_item = index && index < ordered_items.size ? ordered_items[index+1] : nil
  if next_item
    s << '<span class="seq-nav-link">'
    s << link_to('next →', next_item, title: next_item[:title])
    s << '</span>'
  else
    s << '<span class="seq-nav-link disabled">next →</span>'
  end

  '<div class="details"><div class="seq-nav">' + s + '</div></div>'
end
