---
title: "nanoc 4.0 upgrade guide"
---

NOTE: The content of this document is volatile, as nanoc 4.0 is still a work in progress. Nothing described in this document is final.

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

* Build directory
* Auto-prune by default
* Lots of removed stuff
