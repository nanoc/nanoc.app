---
title:      "Variables"
markdown:   advanced
is_dynamic: true
has_toc:    true
---

## Variables

At several points in the compilation process, the context contains several variables that you can use. These variables take the appearance of Ruby instance variables, i.e. prefixed with an `@` sigil (e.g. `@items`) but can also be accessed without the `@` sigil (e.g. `items`). Some filters may not support the `@` notation; in this case, the `@` should be dropped.

## List

`@item_rep`
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

`@site`
: The site.

## Finding items by identifier

The `@items` array supports finding items by identifier by passing the identifier to the `#[]` method. For example,  will return the item with identifier `'/blah/'`:

	#!ruby
	@items['/blah/']

This is functionally identical to the following:

	#!ruby
	@items.find { |i| i.identifier == '/blah/' }

The former is not only a lot shorter, but also significantly faster.

## Common methods

Here are the most commonly used methods for items, item representations and layouts.

### Item

`item.identifier`
: The identifier, starting and ending with a slash (e.g. `/blah/`).

`item[:someattribute]`
: The attribute for the given key.

`item.rep_named(:name)`
: The item representation with the given name.

`item.path`
: Shorthand for `item.rep_named(:default).path`.

`item.compiled_content`
: Shorthand for `item.rep_named(:default).compiled_content`. Pass `:rep` to
  get the compiled content for a non-default rep, and `:snapshot` to get the
  compiled content for a non-default snapshot.

`item.parent`
: The parent of this item, i.e. the item that corresponds with this item’s
  identifier with the last component removed. For example, the parent of the
  item with identifier `/foo/bar/` is the item with identifier `/foo/`.

`item.children`
: The items for which this item is the parent.

See the [`Nanoc::Item` API documentation](/docs/api/Nanoc/Item.html) for details.

**Note:** Avoid using the `item.attributes` hash to get attribute values, as
doing so bypasses the dependency tracking system, possibly resulting in
incorrect output. To get an item attribute, get it directly from the item
instead. For example, use `item[:title]` instead of `item.attributes[:title]`.

### Item representation

`item_rep.item`
: The item for the item rep.

`item_rep.path`
: The path to the item rep, without `index.html`.

`item_rep.name`
: The name of the item rep, e.g. `:default`.

`item_rep.compiled_content`
: Gets the compiled content at the `:default` snapshot. Pass `:snapshot` to get
  the compiled content for a non-default snapshot.

See the [`Nanoc::ItemRep` API documentation](/docs/api/Nanoc/ItemRep.html) for details.

### Layout methods

`layout.identifier`
: The identifier, starting and ending with a slash (e.g. `/blah/`).

`layout[:someattribute]`
: The attribute for the given key.

See the [`Nanoc::Layout` API documentation](/docs/api/Nanoc/Layout.html) for details.

**Note:** Avoid using the `layouts.attributes` hash to get attribute values. For
details, see the [note for Item#identifier above](#item).

## Availability

**In the preprocess block**
: `@items`, `@layouts`, `@config`, `@site`

**In a rule**
: `@items`, `@layouts`, `@config`, `@site`, `@item`

**During filtering**
: `@items`, `@layouts`, `@config`, `@site`, `@item`, `@item_rep`

**During layouting**
: `@items`, `@layouts`, `@config`, `@site`, `@item`, `@item_rep`, `@layout`
