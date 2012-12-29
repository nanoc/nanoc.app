---
title:      "Filters"
has_toc:    true
is_dynamic: true
---

<% require 'kramdown' %>

<h2>Filters index</h2>

<table class="dl">
<% @item.children.sort_by { |i| i[:name] }.each do |f| %>
	<tr>
		<td class="name"><%= link_to "<code>:#{f[:identifiers].first}</code>", f %></td>
		<td class="summary"><%= Kramdown::Document.new(f[:summary]).to_html.gsub(/<\/?p>/, '') %></td>
	</tr>
<% end %>
</table>
