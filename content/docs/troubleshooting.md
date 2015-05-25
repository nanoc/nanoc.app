---
title: "Troubleshooting"
up_to_date_with_nanoc_4: true
---

{:data-nav-title="“Found 3 content files…”""}
## Error: “Found 3 content files for X; expected 0 or 1”

This error occurs when you have multiple files with the same base name, but different extensions. nanoc requires each base name to be unique. For example, the following situation will give raise to this error:

	content/assets/fonts/foo.eot
	content/assets/fonts/foo.otf

nanoc converts these filenames to _identifiers_, which (unless specified otherwise) do not contain the file extension. In the example given above, both filenames correspond to the identifier _/assets/fonts/foo_. Identifiers are required to be unique, and thus nanoc raises an error.

New in nanoc 4 are full identifiers, which _do_ contain the file extension. We recommend upgrading to nanoc 4 and enabling full identifiers as well as glob patterns. See the [nanoc 4 upgrade guide](/docs/nanoc-4-upgrade-guide/) for details.

{:data-nav-title="“Can’t modify frozen…”"}
## Error: “can’t modify frozen…”

Once the compilation process has started, content and attributes of layouts and items are _frozen_, which means they cannot be modified anymore. For example, the following rule is invalid and will cause a “can’t modify frozen Array” error:

	#!ruby
	compile '/articles/**/*'
	  item[:tags] << 'article'
	  filter :erb
	  layout 'default'
	end

What _is_ possible, is modifying content and attributes in the _preprocess_ phase. The preprocess phase is defined using the `preprocess` block in Rules. For example:

	#!ruby
	preprocess do
	  items.select { |i| i.identifier =~ '/articles/**/*' }.each do |i|
	    i[:tags] << 'article'
	  end
	end

In the `preprocess` block, you can access `items`, `layouts`, and `config`. See the [Variables page](/docs/reference/variables/) for details.

{:data-nav-title="“Textual filters cannot be used…”"}
## Error: “Textual filters cannot be used on binary items“

There are two item types in nanoc: textual and binary. Most filters that come with nanoc, such as `:erb` and `:haml`, are textual, meaning they take text as input and produce new text. It is also possible to define binary filters, such as an image thumbnail filter.

It is not possible to run a textual filter on binary items; for example, running `:erb` on an item with filename <span class="filename">content/assets/images/puppy.jpg</span> will cause the “Textual filters cannot be used on binary items” error.

When you are getting this error unexpectedly, double-check your Rules file and make sure that no binary item is filtered through a textual filter. Remember that nanoc will use the first matching rule only!

## Character encoding issues

Character encoding issues manifest themselves in two ways:

* Some characters do not show up correctly in the output (e.g., ä shows up as Ã¤).

* nanoc exits with an error such as `RegexpError: invalid multibyte character`.

In both cases, text in one character encoding is erroneously interpreted as a different character encoding. There are two possible causes for this.

### Wrong output encoding tag

The text could be in the correct encoding, but nanoc or the browser interpret it wrongly.

nanoc’s output is always UTF-8, so the output files should not declare a different encoding. For example, having `<meta charset="iso-8859-1">` at the top of files in <span class="filename">output/</span> is wrong: it should be `<meta charset="utf-8">` instead. You should also ensure that your web server sends the right `Content-Type`.

### Wrong input encoding

The data sources could interpret the input data in the wrong encoding.

nanoc defaults to the current environment encoding, which might not be what you expect. If the environment encoding does not match the actual file encoding, it can lead to errors in the output. There are three ways to solve this:

* You can re-encode your site’s files. If your content files are not in UTF-8, this is probably a good start. Re-encoding into something else than UTF-8 is not recommended.

* You can modify your environment encoding to match the file encoding. If you run into encoding issues with other sites or libraries, it isn’t a bad idea to set your environment up as UTF-8 and get it over with. You should not change your environment to a non-UTF-8 encoding, as UTF-8 is considered the standard character encoding.

* You can set an explicit encoding in the nanoc configuration file. This is the recommended approach, as it never hurts to be explicit.

To set the encoding explicity in the site configuration, open <span class="filename">nanoc.yaml</span> (or <span class="filename">config.yaml</span> on older nanoc sites) and navigate to the section where the data sources are defined. Unless you have modified this section, you will find a single entry for the `filesystem` data source there. In this section, add something similar to `encoding: utf-8` (replacing `utf-8` with whatever you really want). It could look like this:

	#!yaml
	data_sources:
	  -
	    type: filesystem
	    encoding: utf-8

For bonus points, you can do all three. Setting up your content, environment and configuration as UTF-8 is the best way to avoid encoding issues now and in the future.

{:data-nav-title="YAML timestamp issues"}
## Timestamps in YAML files parsed incorrectly

If you work with datetime attributes (such as `created_at`, `published_at` and `updated_at`) and find that the time is one or more hours off, then this section applies to you.

If you use timestamps in the `.yaml` file, be sure to include the timezone. If no timezone is specified, then UTC is assumed—not the local time zone! Quoting the [YAML timestamp specification](http://yaml.org/type/timestamp.html):

> If the time zone is omitted, the timestamp is assumed to be specified in UTC. The time part may be omitted altogether, resulting in a date format. In such a case, the time part is assumed to be 00:00:00Z (start of day, UTC).

We recommend always specifying the time zone.
