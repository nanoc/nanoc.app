---
title:      "Helpers"
has_toc:    true
is_dynamic: true
---

<% @item.children.sort_by { |i| i[:name].to_s }.each do |helper| %>
	<%= render 'autodoc_partial', :item => helper %>
<% end %>
