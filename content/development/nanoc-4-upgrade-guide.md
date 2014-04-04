---
title: "nanoc 4.0 upgrade guide"
---

This document lists all backwards-incompatible changes made to nanoc 4.0, and contains advice on how to migrate from nanoc 3.x to nanoc 4.0.

NOTE: The content of this document is volatile, as nanoc 4.0 is still a work in progress. Nothing described in this document is final. This document is also not guaranteed to be complete yet.

## Removed features

* The `create-item` and `create-layout` commands have been removed. These commands were deemed to be not useful. Instead of using these commands, create items manually on the file system.

* nanoc will no longer attempt to load the Gemfile. Execute nanoc using `bundle exec` instead.

* Support for Ruby 1.8.x has been dropped. Ruby 1.8.x was retired mid 2013.

* The `watch` and `autocompile` commands have been removed. These commands were already deprecated in nanoc 3.6.4. Use [guard-nanoc](https://github.com/guard/guard-nanoc) instead.

* The `filesystem_verbose` data source has been removed. Use the `filesystem` data source instead, as it provides the same functionality.

* The `static` data source has been removed. Its purpose was to work around the nanoc 3.x limitation that identifiers did not include an extension, and that two different items or layouts could therefore not have the same base name. This limitation is no longer present in nanoc 4.x.

* The `update` command has been removed.

* The `view` command has been removed.

NOTE: The decision for removing the <span class="command">update</span> and <span class="command">view</span> commands is not final and might be revisited.

## Minor changed features

* The `filesystem_unified` data source has been renamed to `filesystem`.

* The `output_dir` configuration option has been renamed to `build_dir`, and the default build directory has been changed from `output/` to `build/`. This more clearly communicates the intent of the directory. The `#output_filenames` method in the `Checks` file has been renamed to `#build_filenames`.

* Auto-pruning is now turned on by default. This means that all files in the build directory that do not correspond with a source item will be removed after compilation. If you do not want this behavior, you can opt-out by explicitly setting the `auto_prune` option in the `prune` section of the configration file to `false`.

* nanoc no longer infers the encoding from the environment, but assumes it to be UTF-8 unless explicitly stated otherwise in the data source section fo the configuration file.

## Extracted plugins

TODO: Write this section.

## Identifiers with extensions

TODO: Write this section.

## New globbing syntax

Rules in nanoc 4 use globs. In nanoc 3, the character `*` matches zero or more characters, and `+` matches one or more characters. In nanoc 4, `*` matches any file or directory, and `**` matches directories recursively.

TODO: Describe globs in detail and include examples.

## Compact rules

TODO: Write this section.

nanoc 3.x:

	#!ruby
	compile '*' do
	  # ...
	end

nanoc 4.0:

	#!ruby
	compile '/**/*' do
	  # ...
	end
