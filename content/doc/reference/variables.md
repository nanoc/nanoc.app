---
title:      "Variables"
is_dynamic: true
---

At several moments in the compilation process, Nanoc exposes several variables containing site data. These variables take the appearance of Ruby instance variables, i.e. prefixed with an `@` sigil (e.g. `@items`).

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

The `@config` variable contains the site configuration, read from <span class="filename">nanoc.yaml</span> or <span class="filename">config.yaml</span>.

`@config[:some_key]` &rarr; _object_
: The attribute for the given key, or `nil` if the key is not found.

`@config.fetch(:some_key, fallback)` &rarr; _object_
: The attribute for the given key, or `fallback` if the key is not found.

`@config.fetch(:some_key) { |key| … }` &rarr; _object_
: The attribute for the given key, or the value of the block if the key is not found.

`@config.key?(:some_key)` &rarr; `true` / `false`
: Whether or not an attribute with the given key exists.

The following methods are available during preprocessing:

`@config[:some_key] = some_value` &rarr; _nothing_
: Assigns the given value to the attribute with the given key.

## `@items` and `@layouts`

The `@items` variable contains all items in the site. Similarly, `@layouts` contains all layouts.

`@items[arg]` &rarr; _object_
`@layouts[arg]` &rarr; _object_
: The single item or layout that matches given argument, or nil if nothing is found.

`@items.each { |item| … }` &rarr; _nothing_
`@layouts.each { |item| … }` &rarr; _nothing_
: Yields every item or layout.

`@items.find_all(arg)` &rarr; _collection of items_
`@layouts.find_all(arg)` &rarr; _collection of layouts_
: All items or layouts that match given argument.

`@items.size` &rarr; `Integer`
`@layouts.size` &rarr; `Integer`
: The number of items.

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

The following methods are available during preprocessing:

`@items.delete_if { |item| … }` &rarr; _nothing_
`@layouts.delete_if { |layout| … }` &rarr; _nothing_
: Removes any item or layout for which the given block returns true.

`@items.create(content, attributes, identifier)` &rarr; _nothing_
`@items.create(content, attributes, identifier, binary: true)` &rarr; _nothing_
`@layouts.create(content, attributes, identifier)` &rarr; _nothing_
: Creates an item with the given content, attributes, and identifier. For items, if the `:binary` parameter is `true`, the content will be considered binary.

## `@item`

The `@item` variable contains the item that is currently being processed. This variable is available within compilation and routing rules, as well as while filtering and laying out an item.

`@item[:someattribute]` &rarr; _object_
: The attribute for the given key.

`@item.attributes` &rarr; `Hash`
: A hash containing all attributes of this item.

`@item.binary?` &rarr; `true` / `false`
: Whether or not the source content of this item is binary.

`@item.compiled_content` &rarr; `String`
`@item.compiled_content(rep: :foo)` &rarr; `String`
`@item.compiled_content(snapshot: :bar)` &rarr; `String`
: The compiled content. The `:rep` option specifies the item representation (`:rep` by default), while `:snapshot` specifies the snapshot (`:last` by default).

`@item.fetch(:some_key, fallback)` &rarr; _object_
: The attribute for the given key, or `fallback` if the key is not found.

`@item.fetch(:some_key) { |key| … }` &rarr; _object_
: The attribute for the given key, or the value of the block if the key is not found.

`@item.identifier` &rarr; _identifier_
: The identifier, e.g. `/about.md`, or `/about/` (with legacy identifier format).

`@item.key?(some_key)` &rarr; `true` / `false`
: Whether or not an attribute with the given key exists.

`@item.path` &rarr; `String`
`@item.path(rep: :foo)` &rarr; `String`
`@item.path(snapshot: :bar)` &rarr; `String`
: The path to the compiled item. The `:rep` option specifies the item representation (`:rep` by default), while `:snapshot` specifies the snapshot (`:last` by default).

`@item.reps` &rarr; _collection of reps_
: The collection of representations for this item.

For items that use the legacy identifier format (e.g. `/page/` rather than `/page.md`), the following methods are available:

{: .legacy}
`@item.parent` &rarr; _item_ / `nil`
: The parent of this item, i.e. the item that corresponds with this item’s
  identifier with the last component removed. For example, the parent of the
  item with identifier `/foo/bar/` is the item with identifier `/foo/`.

`@item.children` &rarr; _collection of items_
: The items for which this item is the parent.

The following methods are available during preprocessing:

`@item[:some_key] = some_value` &rarr; _nothing_
: Assigns the given value to the attribute with the given key.

`@item.update_attributes(some_hash)` &rarr; _nothing_
: Updates the attributes based on the given hash.

The item reps collection (`@item.reps`) has the following methods:

`@item.reps[:name]` &rarr; _item rep_ / `nil`
: The item representation with the given name, or `nil` if the requested item rep does not exists.

`@item.reps.each { |rep| … }` &rarr; _nothing_
: Yields every item representation.

`@item.reps.fetch(:name)` &rarr; _item rep_
: The item representation with the given name. Raises if the requested item rep does not exist.

`@item.reps.size` &rarr; `Integer`
: The number of item representations.

Item representation collections include Ruby’s `Enumerable`, which means useful methods such as `#map` and `#select` are available.

## `@layout`

The `@layout` variable contains the layout that is currently being used. This variable is only available while laying out an item.

`@layout[:someattribute]` &rarr; _object_
: The attribute for the given key.

`@layout.attributes` &rarr; `Hash`
: A hash containing all attributes of this layout.

`@layout.fetch(:some_key, fallback)` &rarr; _object_
: The attribute for the given key, or `fallback` if the key is not found.

`@layout.fetch(:some_key) { |key| … }` &rarr; _object_
: The attribute for the given key, or the value of the block if the key is not found.

`@layout.identifier` &rarr; _identifier_
: The identifier, e.g. `/about.md`, or `/about/` (with legacy identifier format).

`@layout.key?(some_key)` &rarr; `true` / `false`
: Whether or not an attribute with the given key exists.

The following methods are available during preprocessing:

`@layout[:some_key] = some_value` &rarr; _nothing_
: Assigns the given value to the attribute with the given key.

`@layout.update_attributes(some_hash)` &rarr; _nothing_
: Updates the attributes based on the given hash.

## `@item_rep` or `@rep`

The `@item_rep` variable contains the item representation that is currently being processed. It is also available as `@rep`. This variable is available while filtering and laying out an item.

`@item_rep.binary?` &rarr; `true` / `false`
: Whether or not the content of this item representation is binary.

`@item_rep.item` &rarr; _item_
: The item for the item rep.

`@item_rep.name` &rarr; `Symbol`
: The name of the item rep, e.g. `:default`.

`@item_rep.path` &rarr; `String`
`@item_rep.path(snapshot: :foo)` &rarr; `String`
: The path to the compiled item representation. The `:snapshot` specifies the snapshot (`:last` by default).

`@item_rep.compiled_content` &rarr; `String`
`@item_rep.compiled_content(snapshot: :bar)` &rarr; `String`
: The compiled content. The `:snapshot` specifies the snapshot (`:last` by default).
