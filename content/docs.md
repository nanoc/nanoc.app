---
title:      "Documentation"
is_dynamic: true
---

<% content_for :details do %>
	<h3>Table of Contents</h3>
	<h4>Getting Started</h4>
	<ul>
		<li><%= link_to_id '/docs/tutorial/' %></li>
		<li><%= link_to_id '/docs/basics/' %></li>
		<li><%= link_to_id '/docs/glossary/' %></li>
	</ul>
	<h4>Topics</h4>
	<ul>
		<li><%= link_to_id '/docs/extending-nanoc/' %></li>
		<li><%= link_to_id '/docs/guides/deploying-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/unit-testing-nanoc-sites/' %></li>
		<li><%= link_to_id '/docs/guides/paginating-articles/' %></li>
		<li><%= link_to_id '/docs/guides/using-filters-based-on-file-extensions/' %></li>
		<li><%= link_to_id '/docs/guides/using-binary-items-effectively/' %></li>
		<li><%= link_to_id '/docs/guides/creating-multilingual-sites/' %></li>
		<li><%= link_to_id '/docs/guides/using-external-sources/' %></li>
		<li><%= link_to_id '/docs/troubleshooting/' %></li>
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
<% end %>

Getting Started
---------------

<ol class="toc big">
  <%= detailed_toc_for('/docs/tutorial/') %>
  <%= detailed_toc_for('/docs/basics/') %>
  <li><%= link_to_id '/docs/glossary/' %></li>
</ol>

Topics
------

<ol class="toc big">
  <%= detailed_toc_for('/docs/extending-nanoc/') %>
  <%= detailed_toc_for('/docs/guides/deploying-nanoc-sites/') %>
  <%= detailed_toc_for('/docs/guides/unit-testing-nanoc-sites/') %>
  <%= detailed_toc_for('/docs/guides/paginating-articles/') %>
  <%= detailed_toc_for('/docs/guides/using-filters-based-on-file-extensions/') %>
  <%= detailed_toc_for('/docs/guides/using-binary-items-effectively/') %>
  <%= detailed_toc_for('/docs/guides/creating-multilingual-sites/') %>
  <%= detailed_toc_for('/docs/guides/using-external-sources/') %>
  <li><%= link_to_id '/docs/troubleshooting/' %></li>
</ol>

References
----------

<ol class="toc">
  <%= detailed_toc_for('/docs/reference/filters/',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/helpers/',   limit: 0) %>
  <%= detailed_toc_for('/docs/reference/commands/',  limit: 0) %>
  <%= detailed_toc_for('/docs/reference/config/',    limit: 0) %>
  <%= detailed_toc_for('/docs/reference/variables/', limit: 0) %>
  <%= detailed_toc_for('/docs/reference/rules/',     limit: 0) %>
  <li><a href="/docs/api/">API documentation</a></li>
</ol>

Other resources
---------------

There is a preliminary [nanoc 4 upgrade guide](nanoc-4-upgrade-guide) that you can use if you want to play around with nanoc 4.

NOTE: nanoc 4 is currently in an early stage. Neither nanoc 4 nor this document are in a final form.
