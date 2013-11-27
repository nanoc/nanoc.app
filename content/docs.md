---

title:      "Documentation Table of Contents"
markdown:   basic
is_dynamic: true
child_desc: "nanoc documentation"

---

<% content_for :details do %>
    <h3>Documentation Index</h3>
    <ol>
	<li><%= link_to_id '/docs/tutorial/' %></li>
	<li><%= link_to_id '/docs/basics/' %></li>
	<li><%= link_to_id '/docs/extending-nanoc/' %></li>
	<li><%= link_to_id '/docs/guides/' %></li>
	<li><%= link_to_id '/docs/reference/' %></li>
	<li><%= link_to_id '/docs/troubleshooting/' %></li>
	<li><%= link_to_id '/docs/glossary/' %></li>
	<li><a href="/docs/api/">API documentation</a></li>
    </ol>
<% end %>

Introduction
------------

<%= detailed_toc_for('/docs/tutorial/') %>
<%= detailed_toc_for('/docs/basics/') %>

Guides
------

<%= detailed_toc_for('/docs/extending-nanoc/') %>
<%= detailed_toc_for('/docs/guides/deploying-nanoc-sites/') %>
<%= detailed_toc_for('/docs/guides/unit-testing-nanoc-sites/') %>
<%= detailed_toc_for('/docs/guides/paginating-articles/') %>
<%= detailed_toc_for('/docs/guides/using-filters-based-on-file-extensions/') %>
<%= detailed_toc_for('/docs/guides/using-binary-items-effectively/') %>
<%= detailed_toc_for('/docs/guides/creating-multilingual-sites/') %>

Appendices
----------

<h3><%= link_to_id '/docs/glossary/' %></h3>

<h3><%= link_to_id '/docs/troubleshooting/' %></h3>

<h3><%= link_to_id '/docs/reference/' %></h3>

<ol>
	<li><%= link_to_id '/docs/reference/filters/' %></li>
	<li><%= link_to_id '/docs/reference/helpers/' %></li>
	<li><%= link_to_id '/docs/reference/commands/' %></li>
	<li><%= link_to_id '/docs/reference/config/' %></li>
	<li><%= link_to_id '/docs/reference/variables/' %></li>
	<li><%= link_to_id '/docs/reference/rules/' %></li>
</ol>

<h3><%= link_to 'API documentation', @items['/docs/troubleshooting/'] %></h3>
