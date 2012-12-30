---
title:      "Reference"
markdown:   basic
is_dynamic: true
---

<% content_for :details do %>
    <h3>Reference Index</h3>
    <p>↑ <%= link_to "Back to #{@item.parent[:title]}", @item.parent %></p>
    <ol>
	<li><%= link_to_id '/docs/reference/filters/' %></li>
	<li><%= link_to_id '/docs/reference/helpers/' %></li>
	<li><%= link_to_id '/docs/reference/commands/' %></li>
    </ol>
<% end %>

Reference index
---------------

This Reference section contains detailed documentation of the following concepts:

* [Filters](/docs/reference/filters/)
* [Helpers](/docs/reference/helpers/)
* [Commands](/docs/reference/commands/)
