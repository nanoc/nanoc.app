---
title: "nanoc 4.0 upgrade guide"
---

NOTE: The content of this document is volatile, as nanoc 4.0 is still a work in progress. Nothing described in this document is final.

## Removed features

* `create-item` and `create-layout` commands
* Bundler support
* `filesystem_verbose`
* `watch` and `autocompile` commands
* `update` command
* Support for Ruby 1.8.x
* Other deprecated stuff (???)

## Changes to Rules

TODO: Describe new identifiers.

Rules in nanoc 4 use globs. In nanoc 3, the character `*` meant zero or more characters, and `+` meant one or more characters. In nanoc 4, `*` means zero or more _non-slash_ characters, and `**` means …

TODO: Describe what <code>**</code> does

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

TODO: Describe compact rules (merged compilation/routing rules).

## Other changes

* Do not infer encoding from environment
* Rename `filesystem_unified` to `filesystem`
* Build directory
* Auto-prune by default
