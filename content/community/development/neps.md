---
title:      "nanoc Enhancement Proposals"
markdown:   basic
has_toc:    true
is_dynamic: true
---

What are NEPs?
--------------

Write me please.

List of nanoc Enhancement Proposals
----------------------------------

<ul>
<% @item.children.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>
