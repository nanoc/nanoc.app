---
title: "Nanoc 4 upgrade guide"
---

Nanoc 4 takes a clean break from the past, removing anything that was holding back future development.

The good news is that Nanoc 4.0 is quite similar to 3.8. Upgrading a Nanoc 3.x site to Nanoc 4.0 only takes minutes.

## Why upgrade?

* Nanoc 4 brings identifiers with extensions, and thereby solves a long-standing usability issue. It also introduces glob patterns, which makes rules easier to write.

* Nanoc 4 paves the way for new features and performance improvements. Nanoc 3 exposed its internals in a public API, making it hard to make significant changes.

* Nanoc 3 is in maintenance mode, which means it will only get critical bug fixes.

## Quick upgrade guide

The following steps will get a Nanoc 3 site working on Nanoc 4 with a minimal amount of changes.

* Upgrade to Ruby 2.2 or higher, or JRuby 9000.

* Change mentions of `Nanoc3` to `Nanoc`.

* Change mentions of `@site.config` to `@config`.

* Add `identifier_type: legacy` to the individual data source configurations.

* Add `string_pattern_type: legacy` to the configuration file.

* In Rules, remove the `rep.` prefix from `filter`, `layout` and `snapshot`. For example:

  {: .legacy}
      #!ruby
      compile '*' do
        rep.filter :erb
        rep.layout 'default'
      end

  {: .new}
      #!ruby
      compile '*' do
        filter :erb
        layout 'default'
      end

* In the `preprocess` block, use `@items.create` rather than instantiating `Nanoc::Item`. For example:

  {: .legacy}
      #!ruby
      @items << Nanoc::Item.new('Hello', {}, '/hello/')

  {: .new}
      #!ruby
      @items.create('Hello', {}, '/hello/')

* In data sources, use `#new_item` or `#new_layout` rather than instantiating `Nanoc::Item` or `Nanoc::Layout`. For example:

  {: .legacy}
      #!ruby
      def items
        [Nanoc::Item.new('Hello', {}, '/hello/')]
      end

  {: .new}
      #!ruby
      def items
        [new_item('Hello', {}, '/hello/')]
      end

* If you use the static data source, disable it for now and follow the extended upgrade instructions below.

## Extended upgrade guide

This section describes how to upgrade a site to identifiers with extensions and glob patterns. For details, see the [identifiers and patterns](/doc/identifiers-and-patterns/) page.

This section assumes you have already upgraded the site using the [quick upgrade guide](#quick-upgrade-guide) above.

Before you start, add `enable_output_diff: true` to the configuration file. This will let the <span class="command">compile</span> command write out a diff with the changes to the compiled output. This diff will allow you to verify that no unexpected changes occur.

TIP: If you use a filter that minifies HTML content, such as `html5small`, we recommend turning it off before upgrading the site, so that the output diff becomes easier to read.

### Enabling glob patterns

Before enabling them, ensure you are familiar with glob patterns. See the [glob patterns](/doc/identifiers-and-patterns/#glob-patterns) section for documentation.

To use glob patterns:

1.  Set `string_pattern_type` to `glob` in the configuration file. For example:

    {: .legacy}
        #!yaml
        string_pattern_type: legacy

    {: .new}
        #!yaml
        string_pattern_type: glob

2.  Ensure that all string patterns in the <span class="filename">Rules</span> file, as well as in calls to `@items[…]`, `@layouts[…]`, and `#render` throughout the site, start and end with a slash. This is an intermediate step. For example:

    {: .legacy}
        #!ruby
        # Before
        compile 'articles/*' do
          layout 'default'
        end

    {: .legacy}
        #!ruby
        # After
        compile '/articles/*/' do
          layout '/default/'
        end

    {: .legacy}
        #!ruby
        # Before
        @items['foo']
        @layouts['/bar']

    {: .legacy}
        #!ruby
        # After
        @items['/foo/']
        @layouts['/bar/']

    {: .legacy}
        #!rhtml
        <!-- Before -->
        <%= render 'header' %>

    {: .legacy}
        #!rhtml
        <!-- After -->
        <%= render '/header/' %>

3.  Replace `*` and `+` with `**/*` in all string patterns in the <span class="filename">Rules</span> file, as well as in calls to `@items[…]`, `@layouts[…]`, and `#render` throughout the site. For example:

    {: .legacy}
        #!ruby
        compile '/articles/*/' do
          layout '/default/'
        end

    {: .new}
        #!ruby
        compile '/articles/**/*/' do
          layout '/default/'
        end

    {: .legacy}
        #!ruby
        @items['/articles/*/']

    {: .new}
        #!ruby
        @items['/articles/**/*/']

This approach should work out of the box: Nanoc should not raise errors and the output diff should be empty.

### Enabling identifiers with extensions

NOTE: This section assumes that glob patterns have been enabled.

Before enabling them, ensure you are familiar with identifiers with extensions. See the [identifiers](/doc/identifiers-and-patterns/#identifiers) section for documentation.

To use identifiers with extensions:

1.  Set `identifier_type` to `full` in the configuration file. For example:

    {: .legacy}
        #!yaml
        identifier_type: legacy

    {: .new}
        #!yaml
        identifier_type: full

2.  Remove the trailing slash from any argument to `#compile`, `#route` and `#layout` in the <span class="filename">Rules</span> file, as well as in calls to `@items[…]`, `@layouts[…]`, and `#render` throughout the site. If the pattern does not end with a “`*`”, add “`.*`”. For example:

    {: .legacy}
        #!ruby
        compile '/articles/**/*/' do
          filter :kramdown
          layout '/default/'
        end

        compile '/about/' do
          layout '/default/'
        end

    {: .new}
        #!ruby
        compile '/articles/**/*' do
          filter :kramdown
          layout '/default.*'
        end

        compile '/about.*' do
          layout '/default.*'
        end

    {: .legacy}
        #!ruby
        @items['/about/']
        @layouts['/default/']

    {: .new}
        #!ruby
        @items['/about.*']
        @layouts['/default.*']

    {: .legacy}
        #!rhtml
        <%= render '/root/' %>

    {: .new}
        #!rhtml
        <%= render '/root.*' %>

4.  Update the routing rules to output the correct path. For example:

    {: .legacy}
        #!ruby
        route '/articles/*/' do
          # /articles/foo/ gets written to /articles/foo/index.html
          item.identifier + 'index.html'
        end

    {: .new}
        #!ruby
        route '/articles/**/*' do
          # /articles/foo.md gets written to /articles/foo/index.html
          item.identifier.without_ext + '/index.html'
        end

5.  Create a routing rule that matches index files in the content directory (such as <span class="filename">content/index.md</span> or <span class="filename">content/blog/index.md</span>). For example, put the following _before_ any rules matching `/**/*`:

    {: .new}
        #!ruby
        route '/**/index.*' do
          # /projects/index.md gets written to /projects/index.html
          item.identifier.with_ext('html')
        end

6.  Replace calls in the form of `@items['/pattern/'].children` with a call to `#find_all` that matches the children. For example:

    {: .legacy}
        #!ruby
        @items['/articles/'].children

    {: .new}
        #!ruby
        @items.find_all('/articles/*')

### Upgrading from the static data source

NOTE: This section assumes that glob patterns and identifiers with extensions have been enabled.

The static data source no longer exists in Nanoc 4. It existed in Nanoc 3 to work around the problem of identifiers not including the file extension, which is no longer the case in Nanoc 4.

Theoretically, with identifiers with extensions enabed, it is possible to move the contents of the <span class="filename">static/</span> directory into <span class="filename">content/</span>. This can be tricky, however, because some rules that did not match any items in <span class="filename">static/</span> might now match.

Because of this, the recommend approach for upgrading is to keep the <span class="filename">static/</span> directory, and set up a new data source that reads from this directory.

In the site configuration, re-enable the static data source, change its type to `filesystem`, set `content_dir` to `"static"` and `layouts_dir` to `null`:

{: .new}
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

{: .new}
    #!ruby
    compile '/static/**/*' do
    end

    route '/static/**/*' do
      # /static/foo.html → /foo.html
      item.identifier.to_s.sub(/\A\/static/, '')
    end

This approach should work out of the box: Nanoc should not raise errors and the output diff should be empty.

A final improvement would be to move the contents of the <span class="filename">static/</span> directory into <span class="filename">content/</span>. The main thing to watch out for with this approach is rules that accidentally match the wrong items.

## Troubleshooting

* If you use Nanoc with a Gemfile, ensure you call Nanoc as <kbd>bundle exec nanoc</kbd>. Nanoc no longer attempts to load the Gemfile.

* If you get a `NoMethodError` error on `Nanoc::Identifier`, call `.to_s` on the identifier before doing anything with it. In Nanoc 4.x, identifiers have their own class and are no longer strings.

  {: .legacy}
      #!ruby
      item.identifier[7..-2]

  {: .new}
      #!ruby
      item.identifier.to_s[7..-2]

* If you get a `NoMethodError` that you did not expect, you might be using a private API that is no longer present in Nanoc 4.0. In case of doubt, ask for help on the [discussion group](http://nanoc.ws/community/#discussion-groups).

## Removed features

The `watch` and `autocompile` commands have been removed. Both were deprecated in Nanoc 3.6. Use [guard-nanoc](https://github.com/guard/guard-nanoc) instead.

Because Nanoc’s focus is now more clearly on compiling content rather than managing it, the following features have been removed:

- the `create-item` and `create-layout` commands
- the `update` and `sync` commands
- VCS integration (along with `Nanoc::Extra::VCS`)
- the `DataSource#create_item` and `DataSource#create_layout` methods.
