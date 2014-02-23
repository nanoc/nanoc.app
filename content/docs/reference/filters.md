---
title:      "Filters"
is_dynamic: true
---

<% @item.children.sort_by { |i| i[:name].to_s }.each do |filter| %>
	<%= render 'autodoc_partial', :item => filter %>
<% end %>
