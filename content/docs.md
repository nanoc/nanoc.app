---
title:      "Documentation"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

<% content_for :details do %>
	<h3>Table of contents</h3>
	<h4>Getting started</h4>
	<ul>
		<li><%= link_to_id '/docs/installation.*' %></li>
		<li><%= link_to_id '/docs/tutorial.*' %></li>
	</ul>
	<h4>Topics</h4>
	<ul>
		<li><%= link_to_id '/docs/sites.*' %></li>
		<li><%= link_to_id '/docs/items-and-layouts.*' %></li>
		<li><%= link_to_id '/docs/cli.*' %></li>
		<li><%= link_to_id '/docs/reference/identifiers-and-patterns.*' %></li>
		<li><%= link_to_id '/docs/reference/rules.*' %></li>
		<li><%= link_to_id '/docs/filters.*' %></li>
		<li><%= link_to_id '/docs/helpers.*' %></li>
		<li><%= link_to_id '/docs/guides/deploying-nanoc-sites.*' %></li>
		<li><%= link_to_id '/docs/guides/unit-testing-nanoc-sites.*' %></li>
		<li><%= link_to_id '/docs/data-sources.*' %></li>
		<li><%= link_to_id '/docs/troubleshooting.*' %></li>
		<li><%= link_to_id '/docs/glossary.*' %></li>
		<li><%= link_to_id '/docs/nanoc-4-upgrade-guide.*' %></li>
	</ul>
	<h4>Tips and tricks</h4>
	<ul>
		<li><%= link_to_id '/docs/guides/paginating-articles.*' %></li>
		<li><%= link_to_id '/docs/guides/using-binary-items-effectively.*' %></li>
		<li><%= link_to_id '/docs/guides/creating-multilingual-sites.*' %></li>
		<li><%= link_to_id '/docs/guides/using-external-sources.*' %></li>
	</ul>
	<h4>References</h4>
	<ul>
		<li><%= link_to_id '/docs/reference/filters.*' %></li>
		<li><%= link_to_id '/docs/reference/helpers.*' %></li>
		<li><%= link_to_id '/docs/reference/commands.*' %></li>
		<li><%= link_to_id '/docs/reference/config.*' %></li>
		<li><%= link_to_id '/docs/reference/variables.*' %></li>
	</ul>
<% end %>

Getting started
---------------

<ol class="toc big">
  <%= detailed_toc_for('/docs/installation.*') %>
  <%= detailed_toc_for('/docs/tutorial.*') %>
</ol>

Topics
------

<ol class="toc big">
  <%= detailed_toc_for('/docs/sites.*') %>
  <%= detailed_toc_for('/docs/items-and-layouts.*') %>
  <%= detailed_toc_for('/docs/cli.*') %>
  <%= detailed_toc_for('/docs/reference/identifiers-and-patterns.*') %>
  <%= detailed_toc_for('/docs/reference/rules.*') %>
  <%= detailed_toc_for('/docs/filters.*') %>
  <%= detailed_toc_for('/docs/helpers.*') %>
  <%= detailed_toc_for('/docs/guides/deploying-nanoc-sites.*') %>
  <%= detailed_toc_for('/docs/guides/unit-testing-nanoc-sites.*') %>
  <%= detailed_toc_for('/docs/data-sources.*') %>
  <%= detailed_toc_for('/docs/troubleshooting.*') %>
  <%= detailed_toc_for('/docs/glossary.*') %>
  <%= detailed_toc_for('/docs/nanoc-4-upgrade-guide.*') %>
</ol>

Tips and tricks
---------------

<ol class="toc big">
  <%= detailed_toc_for('/docs/guides/paginating-articles.*') %>
  <%= detailed_toc_for('/docs/guides/using-binary-items-effectively.*') %>
  <%= detailed_toc_for('/docs/guides/creating-multilingual-sites.*') %>
  <%= detailed_toc_for('/docs/guides/using-external-sources.*') %>
</ol>

References
----------

<ol class="toc">
  <%= detailed_toc_for('/docs/reference/filters.*',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/helpers.*',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/commands.*',  limit: 0) %>
  <%= detailed_toc_for('/docs/reference/config.*',    limit: 0) %>
  <%= detailed_toc_for('/docs/reference/variables.*', limit: 0) %>
</ol>
