---
title:      "Rules"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

The <span class="filename">Rules</span> file contains the processing instructions for all items in a nanoc site. Three different kinds of rules exist:

routing rules
: These rules describe the path where the compiled items should be written to.

compilation rules
: These rules describe the actions that should be executed during compilation (filtering, layouting, and snapshotting).

layouting rules
: These rules describe the filter that should be used for a given layout.

For every item, nanoc finds one compiation rule and one routing rule. Similarly, for every layout, nanoc finds one layouting rule. The first matching rule that is found in the rules file is used. If an item or a layout is not using the correct rule, double-check to make sure that the rules are in the correct order.

## Routing rules

A routing rule describes the path that an item representation is written to inside the output directory. It has the following shape:

    #!ruby
    route '/some/pattern.*' do
      # (routing code here)
    end

The argument for the `#route` method call is a [pattern](/docs/reference/identifiers-and-patterns/#patterns).

The code block should return the routed path for the relevant item. The code block can return nil, in which case the item will not be written.

**Example #1**: The following rule will give the item with identifier <span class="filename">/404.erb</span> the path <span class="filename">/errors/404.php</span>:

    #!ruby
    route "/404.erb" do
      "/errors/404.php"
    end

**Example #2**: The following rule will prevent all items below <span class="filename">/links</span> from being written:

    #!ruby
    route "/links/**/*" do
      nil
    end

In the code block, nanoc exposes `@item` and `@rep`, among others. See the [Variables](/docs/reference/variables/) page for details.

**Example #3**: The following rule will give all identifiers for which no prior matching rule exists a path based directly on its identifier (for example, the item <span class="filename">/foo/bar.html</span> would get the path <span class="filename">/foo/bar/index.html</span>):

    #!ruby
    route "/**/*" do
      @item.identifier.without_ext + "/index.html"
    end

When using a regular expression to match items, the block arguments will contain all matched groups.

**Example #4**: The following rule will capture regex matches and provide them as block arguments (for example, the item with identifier <span class="filename">/blog/2015-05-19-something.md</span> will be routed to <span class="filename">/blog/2015/05/something/index.html</span>):

    #!ruby
    route %r[/blog/([0-9]+)\-([0-9]+)\-([0-9]+)\-([^\/]+)\..*] do |y, m, d, slug|
      "/blog/#{y}/#{m}/#{slug}/index.html"
    end

A `:rep` argument can be passed to the `#route` call. This indicates the name of the representation this rule should apply to. This is `:default` by default, which means routing rules apply to the default representation unless specified otherwise.

**Example #5**: The following rule will apply to all textual representations of all items below <span class="filename">/people</span> (for example, the item <span class="filename">/people/denis.md</span> would get the path <span class="filename">/people/denis.txt</span>):

    #!ruby
    route "/people/**/*", rep: :text do
      item.identifier.with_ext("txt")
    end

When a `:snapshot` argument is passed to a routing rule definition, then that routing rule applies to the given snapshot only. The default value for the `:snapshot` argument is `:last`, meaning that compiled items will only be written once they have been fully compiled.

**Example #6**: The following rules will apply to the `raw` snapshot of all items below <span class="filename">/people</span> (for example, the raw snapshot of the item <span class="filename">/people/denis.md</span> would get the path <span class="filename">/people/denis.txt</span>):

    #!ruby
    route "/people/**/*", snapshot: :raw do
      item.identifier.with_ext("txt")
    end

## Compilation rules

A compilation rule describes how an item should be transformed. It has the following shape:

    #!ruby
    compile "/some/pattern.*" do
      # (compilation code here)
    end

The argument for the `#compile` method call is a [pattern](/docs/reference/identifiers-and-patterns/#patterns).

The code block should execute the necessary actions for compiling the item. The return value of the block is ignored. There are three kinds actions that can be performed:

* **filter** items, transforming their content
* **layout** items, placing their content inside a layout
* **snapshot** items, remembering their content at that point in time for reuse

The code block does not need to execute anything. An empy `#compile` block will not execute anything.

**Example #1**: The following rule will not perform any actions, i.e. the item will not be filtered nor laid out:

    #!ruby
    compile '/images/**/*' do
    end

To filter an item representation, call `#filter` pass the name of the filter as the first argument.

**Example #2**: The following rule will filter items with identifiers ending in `.md` using the `:kramdown` filter, but not perform any layouting:

    #!ruby
    compile '/**/*.md' do
      filter :kramdown
    end

Additional parameters can be given to invocations of `#filter`. This is used by some filters, such as the Haml one (`:haml`), to alter filter behaviour in one way or another.

**Example #3**: The following rule will filter CSS items using the `:relativize_paths` filter, with the filter argument `type` set to `:css`:

    #!ruby
    compile '/**/*.css' do
      filter :relativize_paths, type: :css
    end

To lay out an item representation, call `#layout` and pass the layout identifier as argument.

**Example #4**: The following rule will filter the rep using the `erb` filter, lay out the rep using the layout that matches the `/shiny.*` pattern, and finally run the laid out rep through the `:rubypants` filter:

    #!ruby
    compile '/about.*' do
      filter :erb
      layout '/shiny.*'
      filter :rubypants
    end

In the code block, nanoc exposes `@item` and `@rep`, among others. See the [Variables](/docs/reference/variables/) page for details.

**Example #5**: The following rule will only invoke the `:erb` filter if the item’s `:is_dynamic` attribute is set:

    #!ruby
    compile '/about.*' do
      filter :erb if @item[:is_dynamic]
    end

To take a snapshot of an item representation, call `#snapshot` and pass the snapshot name as argument.

**Example #6**: The following rule will create a snapshot named `:without_toc` so that the content at that snapshot can then later be reused elsewhere:

    #!ruby
    compile '/foo/' do
      filter   :markdown
      snapshot :without_toc
      filter   :add_toc
    end

Just like with routing rules, a `:rep` argument can be passed to the `#compile` call. This indicates the name of the representation this rule should apply to. This is `:default` by default, which means compilation rules apply to the default representation unless specified otherwise.

**Example #7**: The following rule will apply to all items below <span class="filename">/people</span>, and only to textual representations (with name equal to `:text`):

    #!ruby
    compile '/people/**/*', rep: :text do
      # don't filter or layout
    end

When using a regular expression to match items, the block arguments will contain all matched groups. This is more useful for routing rules than it is for compilation rules.

**Example #8**: The following rule will be matched using a regular expression instead of with a wildcard string:

    #!ruby
    compile %r<\A/blog/\d{4}/.*> do
      filter :kramdown
    end

## Layouting rules

To specify the filter used for a layout, use the `#layout` method.

The first argument should be a string containing the identifier of the layout. It can also be a string that contains the `*` wildcard, which matches zero or more characters. Additionally, it can be a regular expression.

The second should be the identifier of the filter to use.

In addition to the first two arguments, extra arguments can be supplied; these will be passed on to the filter.

**Example #1**: The following rule will make all layouts use the `:erb` filter:

    #!ruby
    layout '/**/*', :erb

**Example #2**: The following rule will make the default layout use the `haml` filter and pass a filter argument:

    #!ruby
    layout '/default.*', :haml, format: :html5

**Example #3**: The following rule will be applied to all layouts with identifiers starting with a slash followed by an underscore. For example, <span class="filename">/foo.erb</span> and <span class="filename">/foo/_bar.haml</span> would not match, but <span class="filename">/_foo.erb, <span class="filename">/_foo/bar.html</span> and even <span class="filename">/_foo/_bar.erb</span> would:

    #!ruby
    layout %r{\A/_}, :erb

## Convenience methods

The `#passthrough` method does no filtering or laying out, and copies the matched item as-is. For example:

    #!ruby
    passthrough '/assets/images/**/*'

This is a shorthand for the following:

    #!ruby
    route '/assets/images/**/*' do
      item.identifier.to_s
    end

    compile '/assets/images/**/*' do
    end

The `#ignore` method does no filtering or laying out, and does not write out the matched item. This is useful for items that are only intended to be included in other items. For example:

    #!ruby
    ignore '/assets/style/_*'

This is a shorthand for the following:

    #!ruby
    route '/assets/style/_*' do
      nil
    end

    compile '/assets/style/_*' do
    end

## Pre-processing

The <span class="filename">Rules</span> file can contain a `#preprocess` block. This pre-process block is executed before the site is compiled, and has access to all site data.

Here is an example preprocess block that sets the `author` attribute to `denis` for every article:

    #!ruby
    preprocess do
      @items.each do |item|
        item[:author] = 'denis'
      end
    end

Preprocessors can modify data coming from data sources before it is compiled. It can change item attributes, content and the path, but also add and remove items.

Preprocessors can be used for various purposes. Here are two sample uses:

* A preprocessor could set a `language_code` attribute based on the item path. An item such as `/en/about/` would get an attribute `language_code` equal to `'en'`. This would eliminate the need for helpers such as `language_code_of`.

* A preprocessor could create new (in-memory) items for a given set of items. This can be useful for creating pages that contain paginated items.
