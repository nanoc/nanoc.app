---
title:      "Commands"
is_dynamic: true
---

<% @item.children.sort_by { |i| i[:name].to_s }.each do |command| %>
	<%= render 'autodoc_partial', :item => command %>
<% end %>
