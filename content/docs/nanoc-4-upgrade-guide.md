---
title: "nanoc 4 upgrade guide"
up_to_date_with_nanoc_4: true
---

This document lists all backwards-incompatible changes made to nanoc 4.0, and contains advice on how to migrate from nanoc 3.x to nanoc 4.0.

The good news is that nanoc 4.0 is quite similar to 3.8. Upgrading a nanoc 3.x site to nanoc 4.0 will likely only take minutes.

## Quick upgrade guide

* Upgrade to Ruby 2.2 or higher, or JRuby 9000.

* Change mentions of `Nanoc3` to `Nanoc`.

* Change mentions of `@site.config` to `@config`.

* Add `identifier_type: legacy` to the individual data source configurations.

* Add `string_pattern_type: legacy` to the configuration file.

* In the `preprocess` block, use `@items.create` rather than instantiating `Nanoc::Item`. For example:

      #!ruby
      # Old approach -- NO LONGER WORKS!
      @items << Nanoc::Item.new('Hello', {}, '/hello/')

      # New approach
      @items.create('Hello', {}, '/hello/')

* In data sources, use `#new_item` or `#new_layout` rather than instantiating `Nanoc::Item` or `Nanoc::Layout`. For example:

      #!ruby
      # Old approach -- NO LONGER WORKS!
      def items
        [Nanoc::Item.new('Hello', {}, '/hello/')]
      end

      # New approach
      def items
        [new_item('Hello', {}, '/hello/')]
      end

* If you use the static data source, disable it for now and follow the extended upgrade instructions below.

## Extended upgrade guide

This section describes how to upgrade a site to identifiers with extensions and glob patterns. For details, see the [identifiers and patterns](/docs/reference/identifiers-and-patterns/) page.

This section assumes you have already upgraded the site using the [quick upgrade guide](#quick-upgrade-guide) above.

Before you start, add `enable_output_diff: true` to the configuration file. This will let the <span class="command">compile</span> command write out a diff with the changes to the compiled output. This diff will allow you to verify that no unexpected changes occur.

NOTE: If you use a filter that minifies HTML content, such as `html5small`, we recommend turning it off before upgrading the site, so that the output diff becomes easier to read.

### Enabling glob patterns

Before enabling them, ensure you are familiar with glob patterns. See the [glob patterns](/docs/reference/identifiers-and-patterns/#glob-patterns) section for documentation.

To use glob patterns, remove `string_pattern_type: legacy` from the configuration file. Replace `*` and `+` with `**/*` in the arguments to `#compile`, `#route` and `#layout` in the <span class="filename">Rules</span> file, and also in calls to `@items[…]` and `@layouts[…]` throughout the site.

This approach should work out of the box: nanoc should not raise errors and the output diff should be empty.

Here is an example of a rule that uses the legacy and glob patterns:

    #!ruby
    # With legacy patterns
    compile '/assets/style/*/' do
      # (code here)
    end

    # With glob patterns
    compile '/assets/style/**/*/' do
      # (code here)
    end

Here is an example of legacy and glob patterns in calls to `@items[…]`:

    #!ruby
    # With legacy patterns
    @items['/articles/*/']

    # With glob patterns
    @items['/articles/**/*/']

### Enabling identifiers with extensions

NOTE: This section assumes that glob patterns have been enabled.

TODO: This section is not yet complete.

Before enabling them, ensure you are familiar with identifiers with extensions. See the [identifiers](/docs/reference/identifiers-and-patterns/#identifiers) section for documentation.

To use identifiers with extensions, remove `identifier_type: legacy` from the configuration file.

Here is an example of a rule that uses legacy identifiers and identifiers with extensions:

    #!ruby
    # Without identifiers with extensions
    compile '/assets/style/**/*/' do
      # (code here)
    end

    # With identifiers with extensions
    compile '/assets/style/**/*' do
      # (code here)
    end

Here is an example of identifiers with extensions in calls to `@items[…]`:

    #!ruby
    # Without identifiers with extensions
    @items['/about/']

    # With identifiers with extensions
    @items['/about.*']

TODO: Describe using `item.identifier.extension` rather than `item[:extension]`.

### Upgrading from the static data source

NOTE: This section assumes that glob patterns and identifiers with extensions have been enabled.

The static data source no longer exists in nanoc 4. It existed in nanoc 3 to work around the problem of identifiers not including the file extension, which is no longer the case in nanoc 4.

Theoretically, with identifiers with extensions enabed, it is possible to move the contents of the <span class="filename">static/</span> directory into <span class="filename">content/</span>. This can be tricky, however, because some rules that did not match any items in <span class="filename">static/</span> might now match.

Because of this, the recommend approach for upgrading is to keep the <span class="filename">static/</span> directory, and set up a new data source that reads from this directory.

In the site configuration, re-enable the static data source, change its type to `filesystem`, set `content_dir` to `"static"` and `layouts_dir` to `null`:

    #!yaml
    data_sources:
      -
        type: filesystem
      -
        type: filesystem
        items_root: /static
        content_dir: 'static'
        layouts_dir: null

The null value for the `layouts_dir` option prevents this data source from loading layouts—the other data source already does so.

Lastly, update the rules to copy these items as-is, but without the `/static` prefix:

    #!ruby
    compile '/static/**/*' do
    end

    route '/static/**/*' do
      # /static/foo.html → /foo.html
      item.identifier.to_s.sub(/\A\/static/, '')
    end

This approach should work out of the box: nanoc should not raise errors and the output diff should be empty.

A final improvement would be to move the contents of the <span class="filename">static/</span> directory into <span class="filename">content/</span>. The main thing to watch out for with this approach is rules that accidentally match the wrong items.

## Troubeshooting

* If you use nanoc with a Gemfile, ensure you call nanoc as <kbd>bundle exec nanoc</kbd>. nanoc no longer attempts to load the Gemfile.

* If you get a `NoMethodError` error on `Nanoc::Identifier`, call `.to_s` on the identifier before doing anything with it. In nanoc 4.x, identifiers have their own class and are no longer strings.

      #!ruby
      # Old approach -- NO LONGER WORKS!
      item.identifier[7..-2]

      # New approach
      item.identifier.to_s[7..-2]

* If you get a `NoMethodError` that you did not expect, you might be using a private API that is no longer present in nanoc 4.0. In case of doubt, ask for help on the [discussion group](http://nanoc.ws/community/#discussion-groups).

## Removed features

The `watch` and `autocompile` commands have been removed. Both were deprecated in nanoc 3.6. Use [guard-nanoc](https://github.com/guard/guard-nanoc) instead.

Because nanoc’s focus is now more clearly on compiling content rather than managing it, the following features have been removed:

- the `create-item` and `create-layout` commands
- the `update` and `sync` commands
- VCS integration (along with `Nanoc::Extra::VCS`)
- the `DataSource#create_item` and `DataSource#create_layout` methods.
