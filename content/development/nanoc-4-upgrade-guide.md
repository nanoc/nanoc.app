---
title: "nanoc 4.0 upgrade guide"
---

This document lists all backwards-incompatible changes made to nanoc 4.0, and contains advice on how to migrate from nanoc 3.x to nanoc 4.0.

NOTE: The content of this document is volatile, as nanoc 4.0 is still a work in progress. Nothing described in this document is final. This document is also not guaranteed to be complete yet. If you believe something is missing, please do <a href="https://github.com/nanoc/nanoc.ws/issues/new">open a nanoc.ws issue</a>.

## Identifiers with extensions

In nanoc 4, identifiers include the extension and do not end with a slash. For example, the filename <span class="filename">content/robots.txt</span> maps to the identifier `/robots.txt`, and the filename <span class="filename">content/projects/nanoc.md</span> maps to the identifier `/projects/nanoc.md`.

The <span class="filename">index</span> portion of a filename is no longer stripped in nanoc 4. For example, the filename <span class="filename">content/about/index.html</span> maps to the identifier `/about/index.html`.

Identifiers in nanoc 4 are a first-class concept. Several methods for manipulating an identifier are available. Assuming that `sample` equals an identifier `/projects/nanoc.md`:

`extension`
: Returns the extension. For example, `sample.extension` returns `md`.

`with_ext(s)`
: Returns a new identifier with the extension replaced by `s`. For example, `sample.with_ext('html')` returns `/projects/nanoc.html`.

`without_ext`
: Returns a new identifier with the extension removed. For example, `sample.without_ext` returns `/projects/nanoc`.

`in_dir(dirname)`
: Returns a new identifier with the extension removed, an `index` component added, followed by the original extension. For example, `sample.in_dir` returns `/projects/nanoc/index.md`.

Please consult the [`Nanoc::Identifier` API documentation](/docs/api/core/Nanoc/Identifier.html) for other useful methods.

These methods can be chained together. For example, to recreate nanoc’s default behavior of routing items into their own directory and with the <span class="filename">html</span> extension, you could use `sample.in_dir.with_ext('html')`, which would return `/projects/nanoc/index.html`.

## New globbing syntax

TODO: Rename this to pattern syntax? String pattern syntax?

Rules in nanoc 4 use proper globs. In nanoc 3, the character `*` matches zero or more characters, and `+` matches one or more characters. nanoc 4 uses Ruby’s [`File.fnmatch` method](http://ruby-doc.org/core/File.html#method-c-fnmatch) with the `File::FNM_PATHNAME` option enabled. The three most useful wildcards are the following:

`*`
: Matches any file or directory name. Does not cross directory boundaries. For example, `/projects/*.md` matches `/projects/nanoc.md`, but not `/projects/cri.adoc` nor `/projects/nanoc/about.md`.

`**`
: Matches any file or directory name, and crosses directory boundaries. For example, `/projects/**/*.md` matches both `/projects/nanoc.md` and `/projects/nanoc/history.md`.

`[abc]`
: Matches any single character in the set. For example, `/people/[kt]im.md` matches only `/people/kim.md` and `/people/tim.md`.

Please consult the [`File.fnmatch`](http://ruby-doc.org/core/File.html#method-c-fnmatch) documentation for other supported patterns, and more comprehensive documentation.

NOTE: Extended globs are only available in Ruby 2.0 and up, and are not enabled in nanoc 4. Extended globs allow patterns like <code>/c{at,ub}s.txt</code>, which match either <code>/cats.txt</code> or <code>/cubs.txt</code>.

## Compact rules

In nanoc 3.x, defining how an item is processed happens using both <span class="firstterm">compilation rule</span> and a <span class="firstterm">routing rule</span>.

In nanoc 4.0, routing rules have been merged into compilation rules. Additionally, convenience methods such as `#passthrough` and `#ignore` have been removed.

In nanoc 3.x, a basic compilation/route looks like this:

	#!ruby
	compile '*' do
	  filter :kramdown
	  layout 'default'
	end

	route '*' do
	  item.identifier + 'index.html'
	end

In nanoc 4.0, it looks like this:

	#!ruby
	compile '/**/*' do
	  filter :kramdown
	  layout '/default.*'
	  write item.identifier.in_dir.with_ext('html')
	end

TODO: Handle index filenames in the example correctly.

The compilation rule now includes a `#write` call, with an argument containing the path to the file to write to.

TODO: Highlight pattern-related changes again, and point to the section about the new pattern syntax.

## Extracted plugins

TODO: Write this section.

## Removed features

* The `create-item` and `create-layout` commands have been removed. These commands were deemed to be not useful. Instead of using these commands, create items manually on the file system.

* nanoc will no longer attempt to load the Gemfile. Execute nanoc using `bundle exec` instead.

* Support for Ruby 1.8.x has been dropped. Ruby 1.8.x was retired mid 2013.

* The `watch` and `autocompile` commands have been removed. These commands were already deprecated in nanoc 3.6.4. Use [guard-nanoc](https://github.com/guard/guard-nanoc) instead.

* The `filesystem_verbose` data source has been removed. Use the `filesystem` data source instead, as it provides the same functionality.

* The `filesystem` data source no longer accepts a `allow_periods_in_identifiers` option. With the changes to identifiers made in nanoc 4, this no longer serves a purpose.

* The `static` data source has been removed. Its purpose was to work around the nanoc 3.x limitation that identifiers did not include an extension, and that two different items or layouts could therefore not have the same base name. This limitation is no longer present in nanoc 4.

* The Markaby filter has been removed, as it was not compatible with Ruby 1.9.

* The `update` command has been removed. This command was used to manage source data, which should not have been the responsibility of nanoc.

## Minor changed features

* The `filesystem_unified` data source has been renamed to `filesystem`.

* The `output_dir` configuration option has been renamed to `build_dir`, and the default build directory has been changed from `output/` to `build/`. This more clearly communicates the intent of the directory. The `#output_filenames` method in the `Checks` file has been renamed to `#build_filenames`.

* Auto-pruning is now turned on by default. This means that all files in the build directory that do not correspond with a source item will be removed after compilation. If you do not want this behavior, you can opt-out by explicitly setting the `auto_prune` option in the `prune` section of the configration file to `false`.

* nanoc no longer infers the encoding from the environment, but assumes it to be UTF-8 unless explicitly stated otherwise in the data source section fo the configuration file.

## Developer changes

* All API parts that were previously deprecated have been removed.

* VCS integration has been removed. Its original purpose was to aid in managing source content, but this was deemed to be out of scope for nanoc 4.

* The `Nanoc3` namespace has been removed, and no `Nanoc4` namespace exists. Use `Nanoc` instead.
