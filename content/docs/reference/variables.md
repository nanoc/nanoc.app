---
title:      "Variables"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

At several moments in the compilation process, nanoc exposes several variables containing site data. These variables take the appearance of Ruby instance variables, i.e. prefixed with an `@` sigil (e.g. `@items`).

NOTE: These variables can also be accessed without the `@` sigil (e.g. `items`). Some filters may not support the `@` notation; in this case, the `@` should be dropped.

The following variables exist:

`@item_rep`
`@rep`
: The item representation that is currently being compiled.

`@item`
: The item that is currently being compiled.

`@items`
: The list of all items, including ones that have not yet been compiled.

`@layout`
: The layout that is currently being used in the layout phase.

`@layouts`
: The list of all layouts.

`@config`
: The site configuration as a hash.

There are three contexts in which variables are exposed: in the `preprocess` block, within `compile` and `route` rules, and during filtering/layouting.

## `@config`

The `@config` variable contains the site configuration, read from _nanoc.yaml_.

`@config[:someattribute]`
: The attribute for the given key.

## `@items` and `@layouts`

The `@items` variable contains all items in the site. Similarly, `@layouts` contains all layouts.

`@items[arg]`
`@layouts[arg]`
: Finds a single item or layout using the given argument. See below for details.

`@items.find_all(arg)`
`@layouts.find_all(arg)`
: Finds all items or layouts using the given argument. See below for details.

Both `@items` and `@layouts` include Ruby’s `Enumerable`, which means useful methods such as `#map` and `#select` are available.

To find an item or layout by identifier, passing the identifier to the `#[]` method:

	#!ruby
	@items["/about.md"]

You can also pass a string pattern (_glob_) to `#[]` to find an item or layout whose identifier matches the given string:

	#!ruby
	@layouts["/default.*"]

Additionally, you can pass a regular expression to the `#[]` method, which will find the item or layout whose identifier matches that regex:

	#!ruby
	@items[%r{\A/articles/2014/.*}]

The `#find_all` method is similar to `#[]`, but returns a collection of items or layouts, rather than a single result.

## `@item`

The `@item` variable contains the item that is currently being processed. This variable is available within compilation and routing rules, as well as while filtering and laying out an item.

`@item.identifier`
: The identifier, e.g. `/about.md`, or `/about/` (with legacy identifier format).

`@item[:someattribute]`
: The attribute for the given key.

`@item.path`
: Shorthand for `@item.rep_named(:default).path`.

`@item.compiled_content`
: Shorthand for `@item.rep_named(:default).compiled_content`. Pass `:rep` to
  get the compiled content for a non-default rep, and `:snapshot` to get the
  compiled content for a non-default snapshot.

For items that use the legacy identifier format (e.g. `/page/` rather than `/page.md`), the following methods are available:

{: .legacy}
`@item.parent`
: The parent of this item, i.e. the item that corresponds with this item’s
  identifier with the last component removed. For example, the parent of the
  item with identifier `/foo/bar/` is the item with identifier `/foo/`.

`@item.children`
: The items for which this item is the parent.

## `@layout`

The `@layout` variable contains the layout that is currently being used. This variable is only available while laying out an item.

`@layout.identifier`
: The identifier, e.g. `/page.erb`, or `/page/` (with legacy identifier format).

`@layout[:someattribute]`
: The attribute for the given key.

## `@item_rep` or `@rep`

The `@item_rep` variable contains the item representation that is currently being processed. It is also available as `@rep`. This variable is available wwhile filtering and laying out an item.

`@item_rep.item`
: The item for the item rep.

`@item_rep.path`
: The path to the item rep, without `index.html`.

`@item_rep.name`
: The name of the item rep, e.g. `:default`.

`@item_rep.compiled_content`
: Gets the compiled content at the `:default` snapshot. Pass `:snapshot` to get
  the compiled content for a non-default snapshot.
