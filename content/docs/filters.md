---
title:      "Filters"
has_toc:    true
is_dynamic: true
---

<% require 'kramdown' %>

<h2>Filters index</h2>

<dl class="compact">
<% @item.children.sort_by { |i| i[:name] }.each do |f| %>
	<dt><%= link_to f[:name], f %></dt>
	<dd><%= !f[:summary].empty? ? Kramdown::Document.new(f[:summary]).to_html.gsub(/<\/?p>/, '') : '(no summary available)' %></dd>
<% end %>
</dl>
