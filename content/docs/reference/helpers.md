---
title:      "Helpers"
has_toc:    true
is_dynamic: true
---

<% require 'kramdown' %>

<h2>Helpers index</h2>

<dl>
<% @item.children.sort_by { |i| i[:name] }.each do |helper| %>
	<dt><%= link_to helper[:name], helper %></dt>
	<dd><%= !helper[:summary].empty? ? Kramdown::Document.new(helper[:summary]).to_html.gsub(/<\/?p>/, '') : '(no summary available)' %></dd>
<% end %>
</dl>

