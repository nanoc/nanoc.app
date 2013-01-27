---
title:    "Troubleshooting"
has_toc:  true
markdown: basic
---

## Error: “Found 3 content files for X; expected 0 or 1”

This error occurs when you have multiple files with the same base name, but a different extension. nanoc requires each base name to be unique. For example, the following situation will give raise to this error:

	content/assets/fonts/foo.eot
	content/assets/fonts/foo.otf

There are two ways of resolving this: either giving each file a unique base name and setting up routing rules to write them to the correct location, or using the _static_ data source which includes the extension inside the item identifier. Both solutions are described below.

### Solution #1: Renaming files

The first solution involves renaming so that their base names are unique. For example:

	content/assets/fonts/foo-eot.eot
	content/assets/fonts/foo-otf.otf

Now, you can set up routing rules so that these files are written with the correct filename. For example:

	#!ruby
	route '/assets/fonts/*/' do
	  # /fonts/foo-eot/ -> /fonts/foo.eot
	  item.identifier.sub(/-.+\/$/, '') + item[:extension]
	end

### Solution #2: Using the static data source

nanoc has support for multiple _data sources_, which provide items and layouts. By default, there is only one active: the _filesystem_ data source. This data source reads items from `content/` and layouts from `layouts/`. However, because it strips the file extensions from the item identifier (e.g. `content/foo.md` becomes `/foo/`), it is awkward to use in cases where there are multiple files with the same base name but a different extension.

The `static` data source, bundled with nanoc, _does_ include the file extension in the identifier, and it also marks all items as binary, which makes this data source ideal for handling files that should not be processed but simply copied to the output directory. It loads items from `static/` instead of `content/`. So, for example, an item at `/static/assets/fonts/foo.eot` will get an identifier `/assets/fonts/foo.eot/`.

Setting up the static data source is done by opening `config.yaml` and adding the configuration for a new data source. For example:

	#!yaml
	data_sources:
	  # ... filesystem data source here ...
	  -
	    type: static

You can define an _items root_ here; a prefix that all items from this data source should have. An items root of `/foobar` will make items loaded from the static data source start with `/foobar/`. For example, `static/assets/fonts/foo.eot` would have an identifier of `/foobar/assets/fonts/foo.eot/` instead of just `/assets/fonts/foo.eot/`. This makes it easier to define concise rules. I recommend an `items_root` of `'/static/'`, like this:

	#!yaml
	data_sources:
	  # ... filesystem data source here ...
	  -
	    type: static
	    items_root: /static/

The next step involves setting up a compilation rule, which is quite easy. We match everything below `/static/` (which is out items root) and let it do no processing at all:

	#!ruby
	compile '/static/*' do
	end

The routing rule is a bit more complex. In here, we take the item identifier, strip off the items root and the trailign slash:

	#!ruby
	route '/static/*' do
	  # /static/foo.html/ → /foo.html
	  item.identifier[7..-2]
	end

And that’s it!

## Error: “can’t modify frozen X”

Once the compilation process has started, content and attributes of layouts and items are _frozen_, which means they cannot be modified anymore. For example, the following rule is invalid and will cause a “can’t modify frozen Item” error:

	#!ruby
	compile '/blog/*/'
	  item[:date] = Date.parse(item.identifier[/\d{4}-\d{2}-\d{2}/])
	  filter :erb
	  layout 'default'
	end

What _is_ possible, is modifying content and attributes in the preprocess phase. The preprocess phase is defined using the `preprocess` block in Rules. For example:

	#!ruby
	preprocess do
	  items.select { |i| i.identifier.start_with?('/blog/') }.each do |i|
	    i[:date] = Date.parse(i.identifier[/\d{4}-\d{2}-\d{2}/])
	  end
	end

In the `preprocess` block, you can access `items`, `layouts`, `config` and `site`.

## Textual filters cannot be used on binary items

There are two item types in nanoc: textual and binary. Most filters that come with nanoc, such as `:erb` and `:haml`, are textual, meaning they take text as input and produce new text. It is also possible to define binary filters, such as an image thumbnail filter.

It is not possible to run a textual filter on binary items; for example, running `:erb` on an item with filename `content/assets/images/puppy.jpg` will cause the “Textual filters cannot be used on binary items” error.

When you are getting this error unexpectedly, double-check your Rules file and make sure that no binary item is filtered through a textual filter. Remember that nanoc will use the first matching rule only!

## Pass through an item

If you want to copy an item from `content/` to `output/` without doing any processing at all, then you can use the `#passthrough` method, like this:

	#!ruby
	passthrough '/assets/stylesheets/*/'

This is a shorthand for the following:

	#!ruby
	route '/assets/stylesheets/*/' do
	  item.identifier.chop + item[:extension]
	end

	compile '/assets/stylesheets/*/' do
	end
