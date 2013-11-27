---
title:      "Filters"
has_toc:    true
is_dynamic: true
---

<% require 'kramdown' %>

<% @item.children.sort_by { |i| i[:name].to_s }.each do |filter| %>
	<%= render 'autodoc_partial', :item => filter %>
<% end %>
