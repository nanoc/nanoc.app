---

title:      "Documentation Table of Contents"
markdown:   basic
is_dynamic: true
child_desc: "nanoc documentation"

---

<% content_for :details do %>
	<h3>Documentation Index</h3>
	<h4>Introduction</h4>
	<ol id="first">
		<li><%= link_to_id '/docs/tutorial/' %></li>
		<li><%= link_to_id '/docs/basics/' %></li>
	</ol>
	<h4>Guides</h4>
	<ol>
		<li><%= link_to_id '/docs/extending-nanoc/' %></li>
		<li><%= link_to_id '/docs/guides/deploying-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/unit-testing-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/paginating-articles/' %></li>
		<li><%= link_to_id '/docs/guides/using-filters-based-on-file-extensions/' %></li>
		<li><%= link_to_id '/docs/guides/using-binary-items-effectively/' %></li>
		<li><%= link_to_id '/docs/guides/creating-multilingual-sites/' %></li>
	</ol>
	<h4>Appendices</h4>
	<ol>
		<li><%= link_to_id '/docs/glossary/' %></li>
		<li><%= link_to_id '/docs/troubleshooting/' %></li>
		<li><%= link_to_id '/docs/reference/filters/' %></li>
		<li><%= link_to_id '/docs/reference/helpers/' %></li>
		<li><%= link_to_id '/docs/reference/commands/' %></li>
		<li><%= link_to_id '/docs/reference/config/' %></li>
		<li><%= link_to_id '/docs/reference/variables/' %></li>
		<li><%= link_to_id '/docs/reference/rules/' %></li>
		<li><a href="/docs/api/">API documentation'</a></li>
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

<h3><a href="/docs/api/">API documentation'</a></h3>
