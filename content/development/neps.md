---
title:      "nanoc Enhancement Proposals"
short_title: "NEPs"
markdown:   basic
has_toc:    true
is_dynamic: true
---

What are NEPs?
--------------

The nanoc enhancement proposals (NEPs, inspired by Python’s Python Enhancement Proposals or PEPs) are meant to structure ideas for features, enhancements and changes in general in a more formal way.

If you want to contribute to NEPs, you can either clone the [NEPs repository](https://github.com/nanoc-ssg/neps), make your changes and send me a pull request, or create an issue in the NEPs repository with your remarks. All feedback is welcome!

Quick wins
----------

These NEPs are small and should be fairly easy to implement. If you want to contribute something to nanoc, this is a great place to start.

<ul>
<% @item.children.select { |i| i[:is_quick_win] && i[:status] == 'accepted' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>

List of NEPs
------------

### New

<ul>
<% @item.children.select { |i| i[:status] == 'new' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>

### Accepted

<ul>
<% @item.children.select { |i| i[:status] == 'accepted' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>

### In Progress

<ul>
<% @item.children.select { |i| i[:status] == 'started' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>

### Implemented

<ul>
<% @item.children.select { |i| i[:status] == 'implemented' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>

### Released

<ul>
<% @item.children.select { |i| i[:status] == 'released' }.sort_by { |i| i[:number] }.each do |i| %>
	<li><%= link_to "NEP-#{i[:number]} - #{i[:title]}", i %></li>
<% end %>
</ul>
