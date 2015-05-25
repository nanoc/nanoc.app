---
title:      "Items and layouts"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

Items
-----

Pages, such as an about page, and assets, such as a stylesheet or an image, are collectively called _items_.

An item has content, attributes, and an [identifier](<%= items['/docs/reference/identifiers-and-patterns.*'].path %>).

Item content can be textual or binary. If the extension of the item is included in the site configuration’s [`text_extension`](/docs/reference/config/#text_extensions) list, it is considered to be textual; otherwise, it will be binary. Binary items don’t have their content stored in-memory. Instead, binary items have a filename pointing to the file containing the content.

Each item has attributes (metadata) associated with it. This metadata consists of key-value pairs. All attributes are free-form; there are no predefined attributes.

### Item representations

Every item has one or more <span class="firstterm">item representations</span> (or “reps” for short). An item representation is the compiled form of an item. Some examples of item representations:

* a HTML representation, which will be the default for almost all sites
* a RSS representation, useful for the home page for a blog
* a JSON representation, so that the site can act as a read-only web API
* a [cue sheet](http://en.wikipedia.org/wiki/Cue_sheet_%28computing%29) representation, useful for tracklist pages

An item rep has a name, which usually refers to the format the content is in (`html`, `json`, `rss`, …). Unless otherwise specified, there will be a default representation, aptly named `default`.

### Item snapshots

A snapshot is the compiled content at a specific point during the compilation process. Snapshots can be generated manually, but some snapshots are generated automatically.

The following snapshots are generated automatically:

`:raw`
: The content right before actual compilation is started

`:pre`
: The content right before the item is laid out

`:last`
: The most recent compiled content

Binary items cannot have snapshots.

Layouts
-------

A layout is the “frame” for content to go in to. Typically, a layout adds a header and a footer to a page.

The following is a minimal layout that includes the content using `yield`, and emits some metadata:

	#!eruby
	<html>
	  <head>
	    <title><%%=h @item[:title] %></title>
	  </head>
	  <body>
	    <%%= yield %>
	  </body>
	</html>

An item is laid out using `#layout` function in a compilation rule. See the <%= link_to_id('/docs/reference/rules.*') %> page for details.

Just like items, layouts have attributes and an [identifier](<%= items['/docs/reference/identifiers-and-patterns.*'].path %>).

### Partials

A layout can be used as a <span class="firstterm">partial</span>. A partial is a layout that is not used for laying out an item, but is rather intended to be included into another item or layout. Because of this, partials typically do call `yield`.

To enable partials, first `include` the rendering helper somewhere inside the <span class="filename">lib/</span> directory, such as <span class="filename">lib/helpers.rb</span>:

	#!ruby
	include Nanoc::Helpers::Rendering

To render a partial, call `#render` with the identifier or a glob as an argument:

	#!eruby
	<%%= render '/head.*' %>

It is also possible to pass custom variables to rendered partials by putting them into a hash passed to `#render`. The following example will make a `@title` variable (set to `"Foo"` in this example) available in the `head` layout:

	#!eruby
	<%%= render '/head.*', :title => 'Foo' %>
