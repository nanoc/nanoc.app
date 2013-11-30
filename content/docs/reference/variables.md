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

## Availability

**In the preprocess block**
: `@items`, `@layouts`, `@config`, `@site`

**In a rule**
: `@items`, `@layouts`, `@config`, `@site`, `@item`

**During filtering**
: `@items`, `@layouts`, `@config`, `@site`, `@item`, `@item_rep`

**During layouting**
: `@items`, `@layouts`, `@config`, `@site`, `@item`, `@item_rep`, `@layout`
