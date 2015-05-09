---
title: "nanoc 4.0 upgrade guide"
for_nanoc_4: true
---

This document lists all backwards-incompatible changes made to nanoc 4.0, and contains advice on how to migrate from nanoc 3.x to nanoc 4.0.

NOTE: The content of this document is volatile, as nanoc 4.0 is still a work in progress. Nothing described in this document is final. This document is also not guaranteed to be complete yet. If you believe something is missing, please do <a href="https://github.com/nanoc/nanoc.ws/issues/new">open a nanoc.ws issue</a>.

## Upgrade checklist

* If you use nanoc with a Gemfile, ensure you call nanoc as <kbd>bundle exec nanoc</kbd>. nanoc longer attempts to load the Gemfile.

* If you use the `watch` and `autocompile` commands, use [guard-nanoc](https://github.com/guard/guard-nanoc) instead. Both `watch` and `autocompile` were deprecated in nanoc 3.6.

* Change mentions of `Nanoc3` to `Nanoc`.

* If you get a `NoMethodError` error on `Nanoc::Identifier`, call `.to_s` on the identifier before doing anything with it. In nanoc 4.x, identifiers have their own class and are no longer strings.

      #!ruby
      # Old approach -- NO LONGER WORKS!
      item.identifier[7..-2]

      # New approach
      item.identifier.to_s[7..-2]

* If you create items in the `preprocess` block, use `#create_item` rather than instantiating `Nanoc::Item` instances. For example:

      #!ruby
      # Old approach -- NO LONGER WORKS!
      items << Nanoc::Item.new('Hello', {}, '/hello/')

      # New approach
      items.create('Hello', {}, '/hello/')

* If you create items or layouts in data sources, use `#new_item` or `#new_layout` rather than instantiating `Nanoc::Item` or `Nanoc::Layout` instances. For example:

      #!ruby
      # Old approach -- NO LONGER WORKS!
      def items
        [Nanoc::Item.new('Hello', {}, '/hello/')]
      end

      # New approach
      def items
        [new_item('Hello', {}, '/hello/')]
      end

* If you get a `NoMethodError` that you did not expect, you might be using a private API that is no longer present in nanoc 4.0. In case of doubt, ask for help on the [discussion group](http://nanoc.ws/community/#discussion-groups).

## Removed content management features

Because nanoc’s focus is now more clearly on compiling content rather than managing it, the following features have been removed:

- the `create-item` and `create-layout` commands
- the `update` and `sync` commands
- VCS integration (along with `Nanoc::Extra::VCS`)
- the `DataSource#create_item` and `DataSource#create_layout`.
