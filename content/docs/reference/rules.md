---
title:      "Rules"
is_dynamic: true
---

## Rules

The instructions for processing items are located in a file named `Rules` which lives in a nanoc site directory. This rules file contains _routing rules_, _compilation rules_ and _layouting rules_. Compilation rules determine the actions that should be executed during compilation (filtering, layouting), routing rules determine the path where the compiled files should be written to, and layouting rules determine the filter that should be used for a given layout.

A rule consists of a selector, which identifies which items the rule should be applicable to, and an action block (except for layouting rules), which contains the actions to perform.

Each item has exactly one compilation rule and one routing rule. Similarly, each layout has exactly one layouting rule. The first matching rule that is found in the rules file is used. If an item or a layout is not using the correct rule, double-check to make sure that the rules are in the correct order.

## Routing rules

A routing rule looks like this:

    #!ruby
    route '/foo/' do
      # (routing code here)
    end

The argument for the [`#route`](/docs/api/Nanoc/CompilerDSL.html#route-instance_method) method can be three things:

* the identifier of the item to match
* a string that contains the `*` wildcard, which matches zero or more characters, to match against the item identifier
* a regular expression to match against the item identifier

The code block should return the routed path for the relevant item. The code block can return nil, in which case the item will not be written.

**Example #1**: The following rule will give the item with identifier `/404/` the path `/errors/404.php`:

    #!ruby
    route "/404/" do
      "/errors/404.php"
    end

**Example #2**: The following rule will prevent all items with identifiers starting with `/links/`, including the `/links/` item itself, from being written (the items will still be compiled so that they can be included in other items, however):

    #!ruby
    route "/links/*/" do
      nil
    end

In the code block, you have access to `rep` (also `@rep`), which is the item representation that is currently being processed, and `item` (or `@item`), which is an alias for `@rep.item`.

**Example #3**: The following rule will give all identifiers for which no prior matching rule exists a path based directly on its identifier (for example, the item `/foo/bar/` would get the path `/foo/bar/index.html`):

    #!ruby
    route "*" do
      rep.item.identifier + "index.html"
    end

When using a regular expression to match items, the block arguments will contain all matched groups.

**Example #4**: The following rule will capture regex matches and provide them as block arguments (for example, the item with identifier `/blog/2015-05-19-something/` will be routed to <span class="filename">/blog/2015/05/something/index.html</span>):

    #!ruby
    route %r[/blog/([0-9]+)\-([0-9]+)\-([0-9]+)\-([^\/]+)] do |y, m, d, slug|
      "/blog/#{y}/#{m}/#{slug}/index.html"
    end

A `:rep` argument can be passed to the [`#route`](/docs/api/Nanoc/CompilerDSL.html#route-instance_method) call. This indicates the name of the representation this rule should apply to. This is `:default` by default, which means routing rules apply to the default representation unless specified otherwise.

**Example #5**: The following rule will apply to all items below `/people/`, but not the `/people/` item itself, and only to textual representations (with name equal to `:text`):

    #!ruby
    route "/people/*/", :rep => :text do
      item.identifier.chop + ".txt"
    end

## Compilation rules

A compilation rule looks like this:

    #!ruby
    compile "/foo/" do
      # (compilation code here)
    end

The argument for the `#compile` command is exactly the same as the argument
for `#route`; see above for details.

Just like with routing rules, a `:rep` argument can be passed to the
`#compile` call. This indicates the name of the representation this rule
should apply to. This is `:default` by default, which means compilation
rules apply to the default representation unless specified otherwise.

The code block should execute the necessary actions for compiling the item. It
does not have to return anything.

In the code block, you have access to `@rep`, which is the item representation
that is currently being processed, and `@item`, which is an alias for
`@rep.item`.

A compilation action can either be a filter action, a layout action, or a
snapshot action.

To filter an item representation, call `#filter` pass the name of the filter as argument, along with any other filter arguments. For example, the following will call the `:erb` filter on the current item representation:

    #!ruby
    filter :erb

Additional parameters can be given to invocations of `#filter`. This is used by some filters, such as the Haml one (`:haml`), to alter filter behaviour in one way or another. For example, the following invokes the `:haml` filter with an additional parameter:

    #!ruby
    filter :haml, :format => :html5

To lay out an item representation, call `#layout` and pass the layout identifier as argument. For example, the following will lay out the item representation using the `/default/` layout:

    #!ruby
    layout 'default'

You can run multiple filters and layouts sequentially, like this:

    #!ruby
    filter :erb
    filter :kramdown
    layout 'default'
    filter :rubypants

To take a snapshot of an item representation, call `#snapshot` and pass the snapshot name as argument. For example, the following will create a `:foo` snapshot of the item representation that can later be referred to:

    #!ruby
    snapshot :foo

You’ll usually call `#filter`, `#layout` and `#snapshot` without explicit receiver, but you can also call them on the `@rep` object if you want. The following actions are equivalent:

    #!ruby
    filter :erb
    @rep.filter :erb

    layout 'default'
    @rep.layout 'default'

    snapshot :foo
    @rep.snapshot :foo

**Example #1**: The following rule will not perform any actions, i.e. the item
will not be filtered nor laid out:

    #!ruby
    compile '/sample/one/' do
    end

**Example #2**: The following rule will filter the rep using the `erb` filter,
but not lay out the rep:

    #!ruby
    compile '/samples/two/' do
      filter :erb
    end

**Example #3**: The following rule will filter the rep using the `erb` filter,
lay out the rep using the `shiny` layout, and finally run the laid out rep
through the `rubypants` filter:

    #!ruby
    compile '/samples/three/' do
      filter :erb
      layout '/shiny/'
      filter :rubypants
    end

**Example #4**: The following rule will filter the rep using the
`relativize_paths` filter with the filter argument `type` equal to `css`:

    #!ruby
    compile '/assets/style/' do
      filter :relativize_paths, :type => :css
    end

**Example #5**: The following rule will filter the rep and layout it by
invoking `#filter` or `#layout` with an explicit receiver (with and without @ sign):

    #!ruby
    compile '/samples/three/' do
      @rep.filter :erb
      @rep.layout '/shiny/'
      @rep.filter :rubypants
    end

**Example #6**: The following rule will apply to all items below `/people/`,
and only to textual representations (with name equal to `text`):

    #!ruby
    compile '/people/*', :rep => :text do
      # don't filter or layout
    end

**Example #7**: The following rule will create a snapshot named `without_toc`
so that the content at that snapshot can then later be reused elsewhere:

    #!ruby
    compile '/foo/' do
      filter   :markdown
      snapshot :without_toc
      filter   :add_toc
    end

**Example #8**: The following rule will be matched using a regular expression
instead of with a string. It uses the `%r<>` syntax to define a regular
expression, which avoids escaping slashes, but you could use `//` as well (with
escaping):

    #!ruby
    compile %r</blog/\d{4}/.*/> do
      filter :kramdown
    end

## Layouting rules

To specify the filter used for a layout, use the `#layout` method.

The first argument should be a string containing the identifier of the layout.
It can also be a string that contains the `*` wildcard, which matches zero or
more characters. Additionally, it can be a regular expression.

The second should be the identifier of the filter to use.

In addition to the first two arguments, extra arguments can be supplied; these
will be passed on to the filter.

**Example #1**: The following rule will make all layouts use the `:erb`
filter:

    #!ruby
    layout '*', :erb

**Example #2**: The following rule will make the default layout use the `haml`
filter and pass a filter argument:

    #!ruby
    layout '/default/', :haml, :format => :html5

**Example #3**: The following rule will be applied to all layouts with identifiers starting with a slash followed by an underscore, and ending with a slash. For example, “/foo/” and “/foo/_bar/” would not match, but “/_foo/”, “/_foo/bar/” and even “/_foo/_bar/” would:

    #!ruby
    layout %r{^/_.+/$}, :erb

