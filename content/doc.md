---
title:      "Documentation"
is_dynamic: true
toc:
  - title: 'Getting started'
    children:
      - '/doc/installation.*'
      - '/doc/tutorial.*'
  - title: 'Topics'
    children:
      - '/doc/sites.*'
      - '/doc/items-and-layouts.*'
      - '/doc/cli.*'
      - '/doc/identifiers-and-patterns.*'
      - '/doc/rules.*'
      - '/doc/filters.*'
      - '/doc/helpers.*'
      - '/doc/deploying.*'
      - '/doc/testing.*'
      - '/doc/data-sources.*'
      - '/doc/troubleshooting.*'
      - '/doc/glossary.*'
      - '/doc/nanoc-4-upgrade-guide.*'
  - title: 'Tips and tricks'
    children:
      - '/doc/guides/using-binary-items-effectively.*'
      - '/doc/guides/creating-multilingual-sites.*'
      - '/doc/guides/using-external-sources.*'
  - title: 'References'
    children:
      - '/doc/reference/filters.*'
      - '/doc/reference/helpers.*'
      - '/doc/reference/commands.*'
      - '/doc/reference/config.*'
      - '/doc/reference/variables.*'
---

<% content_for :details do %>
	<h3>Table of contents</h3>
	<h4>Getting started</h4>
	<ul>
		<li><%= link_to_id '/doc/installation.*' %></li>
		<li><%= link_to_id '/doc/tutorial.*' %></li>
	</ul>
	<h4>Topics</h4>
	<ul>
		<li><%= link_to_id '/doc/sites.*' %></li>
		<li><%= link_to_id '/doc/items-and-layouts.*' %></li>
		<li><%= link_to_id '/doc/cli.*' %></li>
		<li><%= link_to_id '/doc/identifiers-and-patterns.*' %></li>
		<li><%= link_to_id '/doc/rules.*' %></li>
		<li><%= link_to_id '/doc/filters.*' %></li>
		<li><%= link_to_id '/doc/helpers.*' %></li>
		<li><%= link_to_id '/doc/deploying.*' %></li>
		<li><%= link_to_id '/doc/testing.*' %></li>
		<li><%= link_to_id '/doc/data-sources.*' %></li>
		<li><%= link_to_id '/doc/troubleshooting.*' %></li>
		<li><%= link_to_id '/doc/glossary.*' %></li>
		<li><%= link_to_id '/doc/nanoc-4-upgrade-guide.*' %></li>
	</ul>
	<h4>Tips and tricks</h4>
	<ul>
		<li><%= link_to_id '/doc/guides/using-binary-items-effectively.*' %></li>
		<li><%= link_to_id '/doc/guides/creating-multilingual-sites.*' %></li>
		<li><%= link_to_id '/doc/guides/using-external-sources.*' %></li>
	</ul>
	<h4>References</h4>
	<ul>
		<li><%= link_to_id '/doc/reference/filters.*' %></li>
		<li><%= link_to_id '/doc/reference/helpers.*' %></li>
		<li><%= link_to_id '/doc/reference/commands.*' %></li>
		<li><%= link_to_id '/doc/reference/config.*' %></li>
		<li><%= link_to_id '/doc/reference/variables.*' %></li>
	</ul>
<% end %>

Getting started
---------------

<ol class="toc big">
  <%= detailed_toc_for('/doc/installation.*') %>
  <%= detailed_toc_for('/doc/tutorial.*') %>
</ol>

Topics
------

<ol class="toc big">
  <%= detailed_toc_for('/doc/sites.*') %>
  <%= detailed_toc_for('/doc/items-and-layouts.*') %>
  <%= detailed_toc_for('/doc/cli.*') %>
  <%= detailed_toc_for('/doc/identifiers-and-patterns.*') %>
  <%= detailed_toc_for('/doc/rules.*') %>
  <%= detailed_toc_for('/doc/filters.*') %>
  <%= detailed_toc_for('/doc/helpers.*') %>
  <%= detailed_toc_for('/doc/deploying.*') %>
  <%= detailed_toc_for('/doc/testing.*') %>
  <%= detailed_toc_for('/doc/data-sources.*') %>
  <%= detailed_toc_for('/doc/troubleshooting.*') %>
  <%= detailed_toc_for('/doc/glossary.*') %>
  <%= detailed_toc_for('/doc/nanoc-4-upgrade-guide.*') %>
</ol>

Tips and tricks
---------------

<ol class="toc big">
  <%= detailed_toc_for('/doc/guides/using-binary-items-effectively.*') %>
  <%= detailed_toc_for('/doc/guides/creating-multilingual-sites.*') %>
  <%= detailed_toc_for('/doc/guides/using-external-sources.*') %>
</ol>

References
----------

<ol class="toc">
  <%= detailed_toc_for('/doc/reference/filters.*',   limit: 0) %>
  <%= detailed_toc_for('/doc/reference/helpers.*',   limit: 0) %>
  <%= detailed_toc_for('/doc/reference/commands.*',  limit: 0) %>
  <%= detailed_toc_for('/doc/reference/config.*',    limit: 0) %>
  <%= detailed_toc_for('/doc/reference/variables.*', limit: 0) %>
</ol>
