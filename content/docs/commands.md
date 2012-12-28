---
title:      "Commands"
has_toc:    true
is_dynamic: true
---

<h2>Commands index</h2>

<dl>
<% @item.children.sort_by { |i| i[:name] }.each do |c| %>
	<dt><%= link_to c[:name], c %></dt>
	<dd><%= c[:summary] %></dd>
<% end %>
</dl>
