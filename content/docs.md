---

title:       "Documentation Table of Contents"
short_title: "Documentation"
is_dynamic:  true

---

<% content_for :details do %>
	<h3>Documentation Index</h3>
	<h4>Introduction</h4>
	<ul>
		<li><%= link_to_id '/docs/tutorial/' %></li>
		<li><%= link_to_id '/docs/basics/' %></li>
	</ul>
	<h4>Guides</h4>
	<ul>
		<li><%= link_to_id '/docs/extending-nanoc/' %></li>
		<li><%= link_to_id '/docs/guides/deploying-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/unit-testing-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/paginating-articles/' %></li>
		<li><%= link_to_id '/docs/guides/using-filters-based-on-file-extensions/' %></li>
		<li><%= link_to_id '/docs/guides/using-binary-items-effectively/' %></li>
		<li><%= link_to_id '/docs/guides/creating-multilingual-sites/' %></li>
	</ul>
	<h4>References</h4>
	<ul>
		<li><%= link_to_id '/docs/reference/filters/' %></li>
		<li><%= link_to_id '/docs/reference/helpers/' %></li>
		<li><%= link_to_id '/docs/reference/commands/' %></li>
		<li><%= link_to_id '/docs/reference/config/' %></li>
		<li><%= link_to_id '/docs/reference/variables/' %></li>
		<li><%= link_to_id '/docs/reference/rules/' %></li>
		<li><a href="/docs/api/">API</a></li>
	</ul>
	<h4>Appendices</h4>
	<ul>
		<li><%= link_to_id '/docs/glossary/' %></li>
		<li><%= link_to_id '/docs/troubleshooting/' %></li>
	</ul>
<% end %>

Introduction
------------

<ol class="toc big">
  <%= detailed_toc_for('/docs/tutorial/') %>
  <%= detailed_toc_for('/docs/basics/') %>
</ol>

Guides
------

<ol class="toc big">
  <%= detailed_toc_for('/docs/extending-nanoc/') %>
  <%= detailed_toc_for('/docs/guides/deploying-nanoc-sites/') %>
  <%= detailed_toc_for('/docs/guides/unit-testing-nanoc-sites/') %>
  <%= detailed_toc_for('/docs/guides/paginating-articles/') %>
  <%= detailed_toc_for('/docs/guides/using-filters-based-on-file-extensions/') %>
  <%= detailed_toc_for('/docs/guides/using-binary-items-effectively/') %>
  <%= detailed_toc_for('/docs/guides/creating-multilingual-sites/') %>
</ol>

Appendices
----------

<ol class="toc">
  <li><%= link_to_id '/docs/glossary/' %></li>
  <li><%= link_to_id '/docs/troubleshooting/' %></li>
  <%= detailed_toc_for('/docs/reference/filters/',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/helpers/',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/commands/',  limit: 0) %>
  <%= detailed_toc_for('/docs/reference/config/',    limit: 0) %>
  <%= detailed_toc_for('/docs/reference/variables/', limit: 0) %>
  <%= detailed_toc_for('/docs/reference/rules/',     limit: 0) %>
  <li><a href="/docs/api/">API documentation</a></li>
</ol>
