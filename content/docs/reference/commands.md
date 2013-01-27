---
title:      "Commands"
has_toc:    true
is_dynamic: true
---

<h2>Commands index</h2>

<table class="dl">
<% @item.children.sort_by { |i| i[:name] }.each do |c| %>
	<tr>
		<td class="name"><%= link_to "<kbd>#{c[:name]}</kbd>", c %></td>
		<td class="summary"><%= c[:summary] %></td>
	</tr>
<% end %>
</table>
