---
title:    "Troubleshooting"
has_toc:  true
markdown: basic
---

## Error: “Found 3 content files for X; expected 0 or 1”

This error occurs when you have multiple files with the same base name, but different extensions. nanoc requires each base name to be unique. For example, the following situation will give raise to this error:

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

Setting up the static data source is done by opening `nanoc.yaml` (on older sites: `config.yaml`) and adding the configuration for a new data source. For example:

	#!yaml
	data_sources:
	  # ... filesystem data source here ...
	  -
	    type: static

You can define an _items root_ here; a prefix that all items from this data source should have. An items root of `/foobar` will prefix items identifier `/foobar/` for all items coming from the static data source. For example, `static/assets/fonts/foo.eot` would have an identifier of `/foobar/assets/fonts/foo.eot/` instead of just `/assets/fonts/foo.eot/`. This makes it easier to define concise rules. I recommend an `items_root` of `'/assets/'`, like this:

	#!yaml
	data_sources:
	  # ... filesystem data source here ...
	  -
	    type: static
	    items_root: /assets/

The next step involves setting up a compilation rule, which is quite easy. We match everything below `/assets/` (which is our items root) and let it do no processing at all:

	#!ruby
	compile '/assets/*' do
	end

The routing rule is a bit more complex. In here, we take the item identifier, strip off the items root and the trailing slash:

	#!ruby
	route '/assets/*' do
	  # /assets/foo.html/ → /foo.html
	  item.identifier[7..-2]
	end

And that’s it! Or you can use a `passthrough` rule (see below).

	#!ruby
	passthrough '/assets/*'

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

## Characters don’t show up right in the output

If you notice that some characters do not show up correctly in the output (e.g., ä shows up as Ã¤), then you are experiencing issues with character encodings: text in one character encoding is erroneously interpreted as a different character encoding. There are two possible causes for this.

### Wrong output encoding tag

The text could be in the correct encoding, but the browser interprets it wrongly.

nanoc’s output is always UTF-8, so the output files should not declare a different encoding. For example, having `<meta charset="iso-8859-1">` at the top of files in output/ is wrong: it should be `<meta charset="utf-8">` instead. You should also ensure that your web server sends the right `Content-Type`.

### Wrong input encoding

The data sources could interpret the input data in the wrong encoding.

nanoc defaults to the current environment encoding, which might not be what you expect. If the environment encoding does not match the actual file encoding, it can lead to errors in the output. There are three ways to solve this:

* You can re-encode your site’s files. If your content files are not in UTF-8, this is probably a good start. Re-encoding into something else than UTF-8 is not recommended.

* You can modify your environment encoding to match the file encoding. If you run into encoding issues with other sites or libraries, it isn’t a bad idea to set your environment up as UTF-8 and get it over with. You should not change your environment to a non-UTF-8 encoding, as UTF-8 is considered the standard character encoding.

* You can set an explicit encoding in the nanoc configuration file. This is the recommended approach, as it never hurts to be explicit.

To set the encoding explicity in the site configuration, open `nanoc.yaml` (or `config.yaml` on older nanoc sites) and navigate to the section where the data sources are defined. Unless you have modified this section, you will find a single entry for the `filesystem_unified` data source there. In this section, add something similar to `encoding: utf-8` (replacing `utf-8` with whatever you really want). It could look like this:

	#!yaml
	data_sources:
	  -
	    type: filesystem_unified
	    encoding: utf-8

For bonus points, you can do all three. Setting up your content, environment and configuration as UTF-8 is the best way to avoid encoding issues now and in the future.

## Timestamps in YAML files parsed incorrectly

If you work with datetime attributes (such as `created_at`, `published_at` and `updated_at`) and find that the time is one or more hours off, then this section applies to you.

If you use timestamps in the `.yaml` file, be sure to include the timezone. If no timezone is specified, then UTC is assumed—not the local time zone! Quoting the [YAML timestamp specification](http://yaml.org/type/timestamp.html):

> If the time zone is omitted, the timestamp is assumed to be specified in UTC. The time part may be omitted altogether, resulting in a date format. In such a case, the time part is assumed to be 00:00:00Z (start of day, UTC).

We recommend always specifying the time zone.
