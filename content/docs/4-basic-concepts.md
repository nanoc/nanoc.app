---

title:                 "Basic Concepts"
markdown:              advanced
toc_includes_sections: true

---

The Commandline Tool
--------------------

Interacting with nanoc happens through a commandline tool named `nanoc3`. (The `nanoc` command can only be used for sites built with nanoc 2.x, not 3.x). `nanoc3` has a few sub-commands, which you can invoke like this:

	> nanoc3 [command]

Here, `command` obviously is the name of the command you’re invoking. A very useful command is the `help` command, which will give you a detailed description of a given command. You can use it like this:

	> nanoc3 help [command]

For example, this is the help for the `create_site` command:

	> nanoc3 help create_site
	nanoc3 create_site [path]

	aliases: cs

	create a site

	    Create a new site at the given path. The site will use the compact
	    filesystem data source by default, but this ccan be changed by
	    using the --datasource commandline option.

	options:

	   -d --datasource specify the data source for the new site

If you want general help, such as a list of available commands and global options, omit the command name, like this:

	> nanoc3 help

So, if you’re ever stuck, consult the the commandline help which (hopefully) will put you back on track.

Sites
-----

A site managed by nanoc is a directory with a specific structure. A site consists of items, layouts, a site configuration and a set of rules.

The way the data in a site is stored depends on the data source that is being used. However, unless you’ve explicitly told nanoc to use a different data source, the `filesystem_compact` one will be used. This manual assumes that this `filesystem_compact` data source is used. For details, see the [Data Sources](#data-sources) section.

### Creating a Site

To create a site, use the `create_site` command. This command takes the site name as its first and only argument, like this:

	> nanoc3 create_site [site_name]

This will create a directory with the given site name, with a bare-bones directory layout.

### Structure

A site has the following files and directories:

`config.yaml`
: contains the site configuration

`content`
: contains the uncompiled items (when using a filesystem data source)

`layouts`
: contains the layouts (when using a filesystem data source)

`lib`
: contains custom site-specific code (filters, helpers, …)

`output`
: contains the compiled site (can be changed in the configuration)

`Rules`
: contains compilation, routing and layouting rules

`tmp`
: contains data used for speeding up compilation (can be safely emptied)

### Code

nanoc will load all Ruby source files in the `lib` directory before it starts compiling. All method definitions, class definitions, etc. will be available during the compilation process. This directory is therefore quite useful for putting in site-wide helpers and filters.

The code for custom data sources should be placed in `lib/data_sources`. The code in this directory will be loaded before any other code. (This is necessary, because the data source is responsible for loading code, but it would only be able to load the code for itself once it’s loaded.)

### Site configuration

The site configuration is defined by the `config.yaml` file at the top level of the site directory. The file is in YAML format.

`data_sources`
: A list of data sources configurations. See below for details.

`index_filenames`
: A list of filenames that should be stripped off paths. This list will usually contain only "index.html", but depending on the production web server used, this may differ. Defaults to a list containing only "index.html".

`output_dir`
: The path to the output directory. If the path does not start with a slash, it is assumed to be a path relative to the nanoc site directory. It defaults to `output`.

The list of data source configurations is a collection of key/value pairs. These key/value pairs are:

`type`
: The type (name) of the data source (e.g. `filesystem_compact`).

`items_root`
: The point where this data source’s items should be mounted. Defaults to `/`.

`layouts_root`
: The point where this data source’s layouts should be mounted. Defaults to `/`.

`config`
: A hash containing extra configuration details (e.g. username, API key).

Custom data sources, filters and helpers may use other configuration attributes. Check their documentation for details.

### (Auto)compiling a Site

To compile a site to its final form, the `nanoc3 compile` or simply `nanoc3 co` command is used. This will write the compiled site to the output directory as specified in the site configuration file. For example:

	> nanoc3 co

nanoc will not compile items that are not outdated. You can tell nanoc to compile all items to pass the `--force` or `-f` flag. Also useful is the `--verbose` or `-V` flag, which turns on extra output.

It is possible to let nanoc run a local web server that serves the nanoc site. Each request will cause the requested item to be compiled on the fly before being served. To run the autocompiler, use `nanoc3 autocompile` or `nanoc3 aco`.

The autocompiler will run on port 3000 by default. To change the port number, use the `-p` or `--port` commandline switch, like this:

	> nanoc3 aco -p 8080

Note that this autocompiler should *only* be used for development purposes to make writing sites easier; it is quite unsuitable for use on live servers.

Items
-----

Items are the basic building blocks of a nanoc-powered site. An item consist of content and metadata attributes.

Items are structured hierarchically. Each item has an identifier that consists of slash-separated parts, which reflects this hierarchy. There is one "root" or "home" page which has path `/`; other items will have paths such as `/journal/2008/some-article/`. The hierarchy of files in the `content` directory reflects this hierarchy.

Item also have a *raw path*, which is where the compiled item will be written to. It is relative to the nanoc site directory and includes the path to the output directory and the terminating "index.html," if any. The *path* of an item is what will be used to link to an item. It is the raw path with the trailing index filenames removed (usually `index.html`). The hierarchy of outputted items does *not* have to be the same as the hierarchy of uncompiled, raw items; see the [routing rules](#routing-rules) section for details.

### Creating an Item

Item can easily be created manually by simply creating its metadata file and content file. It is often easier to create an item using the commandline, though.

To create an item using the commandline, use `nanoc3 create_item` or `nanoc3 ci`. This command takes one argument: the item identifier. For example, to create an item named "bar" with "foo" as parent item, do this:

	> nanoc3 create_item /foo/bar

### Attributes

Each item has attributes (also called "meta-data") associated with it. This metadata consists of key-value pairs, which are stored in YAML format (although this may vary for different data sources). All attributes are free-form; there are no predefined attributes.

Some filters or helpers may use certain attributes. When using these filters, be sure to check their documentation (see below) to see what attributes they use, if any.

### Representations

An item representation (or "rep" for short) is a compiled version of an item. Each representation has a name (a symbol, not a string). An item can have multiple representations, though usually it will have just one (named `default`).

One reason why an item would have different representations is because the data needs to be available in multiple formats. For example, HTML and XHTML. You could also have a `raw` representation that isn’t compiled at all (just the raw, unfiltered, non-laid out content). Sometimes, it may even be useful to have XML, YAML or JSON representations of an item.

An item’s list of representation can be fetched by calling `#reps` on the `Nanoc3::Item` instance. To get a specific rep, use `Enumerable#find`, like this:

<pre><code class="language-ruby">
rep = @item.reps.find { |r| r.name == :default }
</code></pre>

### Snapshots

A representation contains multiple versions of its compiled content. "Snapshots" of the compiled content are automatically created at specific points in the compilation process, but can also be made manually.

To get the compiled content of a representation at a specific snapshot, use `#content_at_snapshot`, like this:

<pre><code class="language-ruby">
compiled_content = rep.content_at_snapshot(:last)
</code></pre>

If you only have an item (a `Nanoc3::Item` instance) and not a rep (a `Nanoc3::ItemRep` instance), you can use something like this to get the compiled content of the first rep of the given item:

<pre><code class="language-ruby">
compiled_content = @item.reps[0].content_at_snapshot(:last)
</code></pre>

The automatically generated snapshots are:

`:raw`
: The content right before actual compilation is started

`:pre`
: The content right before the item is laid out

`:post`
: The content after the item has been laid out and post-filtered

`:last`
: The most recent compiled content

The `:post` and `:last` snapshots will usually be the same. The difference is that `:last` is a moving snapshot: it always refers to the last compiled content. `:last` may refer to `:raw` or `:pre` early on, but may point to `:post` later. Also, there will _always_ be a `:last` snapshot but not necessary a `:post` snapshot (for example, items without layouts).

Note that the `:pre` snapshot is relative to the last `layout` call: the `:pre` snapshot will contain the content right before the last layout; not the first.

### Variables

When compiling items with filters that support adding code to the item or the layout (such as ERB and Haml), several variables are made available. These variables are:

`@item_rep`
: The item representation that is currently being compiled.

`@item`
: The item that is currently being compiled.

`@items`
: The list of all items, including ones that have not yet been compiled.

`@layout`
: The layout that is currently being used in the layout phase.

`@layouts`
: The list of all layouts.

`@config`
: The site configuration as a hash.

`@site`
: The site.

To get an item attribute, use the `#[]` method and pass the attribute key as a symbol, e.g. `@item[:author]`.

Items have the following attributes available at compile time:

`mtime`
: The time when the item was last modified.

`parent`
: The parent of this item. The root item will have a `nil` parent.

`children`
: A list of child items. This may be an empty array.

`reps`
: A list of representations for this item.

`path`
: The item’s path relative to the web root, with leading and trailing slashes, e.g. `/blog/`.

To get a item representation with a specific name, get the reps by using the `#reps` method and then find the right rep. For example, to get the "raw" representation:

<pre><code class="language-ruby">
raw_rep = @item.reps.find { |r| r.name == :raw }
</code></pre>

It is not possible to get the compiled content of an item; items themselves have no compiled content but their reps do. For example, to get the compiled content of a certain item:

<pre><code class="language-ruby">
content = item.reps[0].content_at_snapshot(:pre)
</code></pre>

Layouts
-------

On itself, an item’s content is not valid HTML yet: it lacks the structure a typical HTML document has. A layout is used to add this missing structure to the item.

For a layout to be useful, it must output the item’s content at a certain point. This is done by outputting `yield`. This extremely minimal layout shows an example of how this is usually done:

<pre><code class="language-html_rails">
&lt;html>
  &lt;head>
    &lt;title>&lt;%=h @item[:title] %>&lt;/title>
  &lt;/head>
  &lt;body>
&lt;%= yield %>
  &lt;/body>
&lt;/html>
</code></pre>

An item is put into a layout by calling the `layout` function in a compilation rule. See the [Compilation Rules](#compilation-rules) section for details.

### As Partials

Layouts can also be used as *partials*: a specific layout can be rendered into an item or a layout by using the `render` function, which takes the layout name as an argument. For example:

<pre><code class="language-html_rails">
&lt;%= render 'head' %>
</code></pre>

For this to work, though, you’ll first have to activate the `Rendering` helper (see the [helpers](#helpers) section for details), which is done by adding this line of code to some file in the `lib` directory (I recommend `lib/helpers.rb`):

<pre><code class="language-ruby">
include Nanoc3::Helpers::Rendering
</code></pre>

It is also possible to pass custom variables to rendered partials by putting them into a hash passed to `render`. The following example will make a `@title` variable (set to "Foo" in this example) available in the "head" layout:

<pre><code class="language-html_rails">
&lt;%= render 'head', :title => 'Foo' %>
</code></pre>

Rules
-----

In order to figure out how to compile an item, nanoc uses processing instructions located in a file called `Rules` which lives at the top level of the nanoc site directory.

The file contains three different kinds of rules: routing rules, compilation rules and layouting rules. Compilation rules determine the actions that should be executed during compilation (filtering, layouting); routing rules determine the path where the compiled files should be written to; layouting rules determine the filter that should be used for a given layout.

A rule consists of a selector, which identifies which items the rule should be applicable to, and an action block (except for layouting rules), which contains the actions to perform.

nanoc will first attempt to build a route for each item. To do so, it will run through all items and find the first matching rule for each item. Only the first matching rule will be used; matching rules that come later will be ignored. Once all items are routed, nanoc will run through all items and find the first matching compilation rule and apply that to the relevant item.

### Routing Rules

A routing rule looks like this:

<pre><code class="language-ruby">
route '/foo/' do
  # … routing code here …
end
</code></pre>

The argument for the `#route` method is the identifier of the item that should
be compiled. It can also be a string that contains the `*` wildcard, which
matches zero or more characters. Additionally, it can be a regular expression.

A `:rep` argument can be passed to the `#route` call. This indicates the
name of the representation this rule should apply to. This is `:default` by
default, which means routing rules apply to the default representation unless
specified otherwise.

The code block should return the routed path for the relevant item. The code
block can return nil, in which case the item will not be written.

In the code block, you have access to `rep`, which is the item representation
that is currently being processed, and `item`, which is an alias for
`rep.item`.

Example #1: The following rule will give the item with identifier `/404/` the
path `/error/404.php` (in nanoc 2.2, this would have been done using the
`custom_path` attribute):

<pre><code class="language-ruby">
route '/404/' do
  '/errors/404.php'
end
</code></pre>

Example #2: The following rule will give all identifiers for which no prior
matching rule exists a path based directly on its identifier (for example, the
item `/foo/bar/` would get the path `/foo/bar/index.html`):

<pre><code class="language-ruby">
route '*' do
  rep.item.identifier + 'index.html'
end
</code></pre>

Example #3: The following rule will prevent all items with identifiers
starting with '/links/' from being written (the items will still be compiled
so that they can be included in other items, however):

<pre><code class="language-ruby">
route '/link/*' do
  nil
end
</code></pre>

Example #4: The following rule will apply to all items below `/people/`, and
only to textual representations (with name equal to `text`):

<pre><code class="language-ruby">
route '/people/*', :rep => :text do
  item.identifier + '.txt'
end
</code></pre>

### Compilation Rules

A compilation rule looks like this:

<pre><code class="language-ruby">
compile '/foo/' do
  # … compilation code here …
end
</code></pre>

The argument for the `#compile` command is exactly the same as the argument
for `#route`; see above for details.

Just like with routing rules, a `:rep` argument can be passed to the
`#compile` call. This indicates the name of the representation this rule
should apply to. This is `:default` by default, which means compilation
rules apply to the default representation unless specified otherwise.

The code block should execute the necessary actions for compiling the item. It
does not have to return anything.

In the code block, you have access to `rep`, which is the item representation
that is currently being processed, and `item`, which is an alias for
`rep.item`.

A compilation action can either be a filter action or a layout action. To
filter an item representation, call `#filter` on the rep and pass the name of
the filter as argument, along with any other filter arguments. To lay out an
item representation, call `#layout` on the rep and pass the layout identifier
as argument. To take a snapshot of an item representation, call `#snapshot` on
the rep and pass the snapshot name as argument.

`#filter`, `#layout` and `#snapshot` can be called without explicit receiver.

Example #1: The following rule will not perform any actions, i.e. the item
will not be filtered nor laid out:

<pre><code class="language-ruby">
compile '/sample/one/' do
end
</code></pre>

Example #2: The following rule will filter the rep using the `erb` filter, but
not lay out the rep:

<pre><code class="language-ruby">
compile '/samples/two/' do
  rep.filter :erb
end
</code></pre>

Example #3: The following rule will filter the rep using the `erb` filter, lay
out the rep using the `shiny` layout, and finally run the laid out rep through
the `rubypants` filter:

<pre><code class="language-ruby">
compile '/samples/three/' do
  rep.filter :erb
  rep.layout '/shiny/'
  rep.filter :rubypants
end
</code></pre>

Example #4: The following rule will filter the rep using the
`relativize_paths` filter with the filter argument `type` equal to `css`:

<pre><code class="language-ruby">
compile '/assets/style/' do
  rep.filter :relativize_paths, :type => :css
end
</code></pre>

Example #5: The following rule will filter the rep and layout it without
invoking `#filter` or `#layout` with an explicit receiver:

<pre><code class="language-ruby">
compile '/samples/three/' do
  filter :erb
  layout '/shiny/'
  filter :rubypants
end
</code></pre>

Example #6: The following rule will apply to all items below `/people/`, and
only to textual representations (with name equal to `text`):

<pre><code class="language-ruby">
compile '/people/*', :rep => :text do
  # don’t filter or layout
end
</code></pre>

Example #7: The following rule will create a snapshot named `without_toc`
so that the content at that snapshot can then later be reused elsewhere:

<pre><code class="language-ruby">
compile '/foo/' do
  filter :markdown
  snapshot :without_toc
  filter :add_toc
end
</code></pre>

### Layouting Rules

To specify the filter used for a layout, use the `#layout` method.

The first argument should be a string containing the identifier of the layout.
It can also be a string that contains the `*` wildcard, which matches zero or
more characters. Additionally, it can be a regular expression.

The second should be the identifier of the filter to use.

In addition to the first two arguments, extra arguments can be supplied; these
will be passed on to the filter.

Example #1: The following rule will make all layouts use the `:erb` filter:

<pre><code class="language-ruby">
layout '*', :erb
</code></pre>

Example #2: The following rule will make the default layout use the `haml`
filter and pass a filter argument:

<pre><code class="language-ruby">
layout '/default/', :haml, :format => :html5
</code></pre>

The Compilation Process
-----------------------

Compiling a site involves several steps:

1. Loading the site data
2. Preprocessing the site data
3. Building the item representations
4. Routing the item representations
5. Compiling the item representations

### Loading the Site Data

Before compilation starts, all data from all data sources will be read (items, layouts and code snippets) and mounted at the roots specified by the data sources. For more information about data sources, see the [Data Sources](#data-sources) section.

### Preprocessing the Site Data

After the data is loaded, it is _preprocessed_ if a preprocessor block exists. A preprocessor block is a simple piece of code defined in the `Rules` file that will be executed after the data is loaded. It looks like this:

<pre><code class="language-ruby">
preprocess do
  # …
end
</code></pre>

Preprocessors can modify data coming from data sources before it is compiled. It can change item attributes, content and the path, but also add and remove items.

Preprocessors can be used for various purposes. Here are two sample uses:

* A preprocessor could set a `language_code` attribute based on the item path. An item such as `/en/about/` would get an attribute `language_code` equal to `'en'`. This would eliminate the need for helpers such as `language_code_of`.

* A preprocessor could create new (in-memory) items for a given set of items. This is what happens on the nanoc site, where the news archive’s pagination pages are created during the preprocessing phase.

### Building the Item Representations

Once the data is loaded and preprocessed, item representations are built for each item. For each item, its compilation rules (one per item rep) are looked up and a rep is built for each rule.

For example, the following code will cause the item `/foo/` to have only one rep (`default`), while the item `/bar/` will have two reps (`raw` and `full`):

<pre><code class="language-ruby">
compile '/foo/' do
  # …
end

compile '/bar/', :rep => :raw do
  # …
end

compile '/bar/', :rep => :full do
  # …
end
</code></pre>

### Routing the Item Representations

For each item representation, the matching routing rule is looked up and applied to the item rep. The item rep’s path to the output file will be set to the return value of the routing rule block.

The routing rule block can also return nil, in which case the item representation will not be written to the disk—useful when items should be included as part of other, larger items, but should not exist separately.

### Compiling the Item Representations

Compiling an item means compiling all of its representations, which in turn involves executing the compilation rules on each representation. After a compilation rule has been applied, the item representation’s compiled content will be written to its output file (if it has one) determined by its routing rule.

The following diagram illustrates item compilation by giving a few examples of how items can be filtered and laid out.

<div class="figure">
	<img src="/assets/images/manual/item_compilation_diagram.png" alt="Diagram giving several examples of how items can be filtered and laid out">
</div>

Items that have content dependencies on other items, i.e. items that include the content of another item, will be compiled once the content of the items it depends on is available. Circular content dependencies (item "A" requiring the content of item "B" and vice versa) are detected and reported.

By default, item representations will not be recompiled unless they are outdated. This provides a noticeable speedup, especially for large sites. The `compile` and `autocompile` commands accept a `-f` or `--force` switch, which recompiles items even if they are not outdated.

Filters
-------

Filters are used for transforming an item’s content. For example, the ERB filter interprets the item’s content as text with embedded Ruby, executes the embedded Ruby and returns the result.

Each filter has an identifier (a symbol), which is used in the call to `#filter` in a compilation rule.

### List of Built-in Filters

`bluecloth`
: for [Markdown](http://daringfireball.net/projects/markdown/) (uses [BlueCloth](http://www.deveiate.org/projects/BlueCloth))

`coderay`
: for [CodeRay](http://coderay.rubychan.de/)

`erb`
: for embedded Ruby (uses [ERB](http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/))

`erubis`
: for embedded Ruby (uses [Erubis](http://www.kuwata-lab.com/erubis/))

`haml`
: for [Haml](http://haml.hamptoncatlin.com/)

`less`
: for [LESS](http://lesscss.org/)

`markaby`
: for [Markaby](http://markaby.rubyforge.org/)

`maruku`
: for [Markdown](http://daringfireball.net/projects/markdown/) (uses [Maruku](http://maruku.rubyforge.org/))

`rainpress` 
: for [Rainpress](http://code.google.com/p/rainpress/)

`rdiscount`
: for [Markdown](http://daringfireball.net/projects/markdown/) (uses [RDiscount](http://github.com/rtomayko/rdiscount/tree/master))

`rdoc` 
: for [RDoc](http://rdoc.sourceforge.net/)&#8217;s Simple Markup

`redcloth`
: for [Textile](http://www.textism.com/tools/textile/) (uses [RedCloth](http://whytheluckystiff.net/ruby/redcloth/))

`relativize_paths`
: for making paths in HTML and CSS relative

`rubypants`
: for [SmartyPants](http://daringfireball.net/projects/smartypants/) (uses [RubyPants](http://chneukirchen.org/blog/static/projects/rubypants.html))

`sass`
: for [Sass](http://haml.hamptoncatlin.com/docs/rdoc/classes/Sass.html)

Filter arguments for the `haml` and `sass` filters will be passed to `Haml::Engine.new` and `Sass::Engine.new`, respectively (with the exception of `:filename`, which will be set to the item rep name).

The `relativize_paths` filter makes all paths in HTML or CSS relative. To set the type of data to relativize (HTML or CSS) pass `:type => :html` resp. `:type => :css`. For example, a reference from the `/about/` item to the `/journal/` item will become `../journal/` instead of `/journal/`. This filter uses the <a href="/doc/3.0.0/Nanoc3/Helpers/LinkTo.html">LinkTo helper</a>’s `relative_path_to` function. When using it with HTML, it relativizes all paths in `src=""` and `href=""` attributes; when using it with CSS, it relativizes all paths in `url()` properties.

### Writing Filters

Filters are classes that inherit from `Nanoc3::Filter`. They have one important method, `#run`, which takes the content to filter and a list of parameters, and returns the filtered content. For example:

<pre><code class="language-ruby">
class CensorFilter &lt; Nanoc3::Filter
  def run(content, params={})
    content.gsub('nanoc sucks', 'nanoc rocks')
  end
end
</code></pre>

A filter has an identifier, which is an unique name that is used in calls to `#filter` in a compilation rule. A filter identifier is set using `#identifier`, like this:

<pre><code class="language-ruby">
class CensorFilter &lt; Nanoc3::Filter
  identifier :censor
  # … other code goes here …
end
</code></pre>

A filter has access to an `assigns` variable, which is a hash that contains several useful values:

`:item`
: The item whose content is being filtered

`:item_rep`
: The item rep whose content is being filtered

`:items`
: A list of all items in the current site

`:layouts`
: A list of all layouts in the current site

`:config`
: The configuration of the current site

`:site`
: The current site

Helpers
-------

A helper is a module with useful functions that can be used in items and layouts.

Helpers need to be activated before they can be used. To activate a helper, `include` it, like this (in a file in the `lib` directory, such as `lib/helpers.rb`):

<pre><code class="language-ruby">
include Nanoc3::Helpers::Blogging
</code></pre>

### List of Built-in Helpers

nanoc comes with a couple of built-in helpers. These helpers all all child modules of `Nanoc3::Helpers` (so `Blogging` is actually `Nanoc3::Helpers::Blogging`).

`Blogging`
: provides blogging and Atom feed features (<a href="/doc/3.0.0/Nanoc3/Helpers/Blogging.html">documentation</a>)

`Breadcrumbs`
: provides functionality for generating breadcrumb trails (<a href="/doc/3.0.0/Nanoc3/Helpers/Breadcrumbs.html">documentation</a>)

`Capturing`
: provides functionality for capturing and reusing content (<a href="/doc/3.0.0/Nanoc3/Helpers/Capturing.html">documentation</a>)

`Filtering`
: provides ability to filter parts of items (<a href="/doc/3.0.0/Nanoc3/Helpers/Filtering.html">documentation</a>)

`HTMLEscape`
: provides a HTML escaping function (<a href="/doc/3.0.0/Nanoc3/Helpers/HTMLEscape.html">documentation</a>)

`LinkTo`
: provides `link_to` and `link_to_unless_current` functions (<a href="/doc/3.0.0/Nanoc3/Helpers/LinkTo.html">documentation</a>)

`Rendering`
: provides functionality for rendering layouts as partials (<a href="/doc/3.0.0/Nanoc3/Helpers/Rendering.html">documentation</a>)

`Tagging`
: provides functionality for printing a item’s tags (<a href="/doc/3.0.0/Nanoc3/Helpers/Tagging.html">documentation</a>)

`Text`
: provides various text/HTML-related functions (<a href="/doc/3.0.0/Nanoc3/Helpers/Text.html">documentation</a>)

`XMLSitemap`
: provides functionality for creating XML sitemaps (<a href="/doc/3.0.0/Nanoc3/Helpers/XMLSitemap.html">documentation</a>)

Rake Tasks
----------

nanoc comes with a couple of useful built-in rake tasks. To use them, require them in your rakefile, like this:

<pre><code class="language-ruby">
require 'nanoc3/tasks'
</code></pre>

The tasks that come with nanoc are:

`clean`
: Removes all files generated by nanoc from the output directory.

`deploy:rsync`
: Deploys the site to a remote server using `rsync`. See below for details.

`validate:css`
: Validates the site’s CSS files.

`validate:html`
: Validates the site’s HTML files.

Please note that the HTML/CSS validation tasks validate each file by sending it to the W3C validator. Depending on the number of files you have, this may be quite slow.

### rsync Deployment Configuration

In order to use the deploy rake task, the site configuration needs to have deployment configuration. This is the `deploy` hash, which in turn consists of separate hashes that contain each deployment configuration.

Each deployment configuration needs a `dst` key, containing the destination to where should be deployed. It can also contain an optional `options` hash, which is an array of options to pass to rsync.

Here’s an example `config.yaml` that shows the deployment configuration:

<pre><code class="language-yaml">
deploy:
  default:
    dst:     "myserver:/var/www/mysite"
    options: [ '-gpPrvz', '--exclude=".svn"' ]
</code></pre>

Data Sources
------------

Each site has one or more _data sources_: objects that can load site data such as items and layouts from certain locations, and even create new items and layouts.

New nanoc sites will have only one data source: the `filesystem_compact` one (see the [FilesystemCompact](#filesystemcompact) section for details). To create a site with a different data source, use the `create_site` command with the `--datasource` option, like this:

	nanoc3 create_site my_new_site --datasource=filesystem_combined

The site configuration has a list of hashes containing the data source configurations. Each list item is a hash with the following keys:

`type`
: The type of data source to use (`filesystem_compact`, `filesystem_combined`, `filesystem`, `delicious`, `twitter`, `last_fm`, …)

`items_root`
: The root where items should be mounted. Optional; defaults to `/`.

`layouts_root`
: The root where layouts should be mounted. Optional; defaults to `/`.

`config`
: A hash containing custom configuration options for the data source. The contents of this hash depends on the data source used; see the documentation of the data source for details.

For example, the configuration of a site that uses many data sources could look like this:

<pre><code class="language-yaml">
data_sources:
  -
    type:       'filesystem_compact'
  -
    type:       'twitter'
    items_root: '/tweets'
    config:
      username: 'ddfreyne'
  -
    type:       'delicious'
    items_root: '/links'
    config:
      username: 'ddfreyne'
  -
    type:       'last_fm'
    items_root: '/tracks'
    config:
      username: 'amonre'
      limit:    '10'
      api_key:  '1234567890abcdefghijklmnopqrstuv'
</code></pre>

nanoc comes bundled with the following data sources:

`filesystem_compact`
: Reads data from files on the disk ([documentation](/doc/3.0.0/Nanoc3/DataSources/FilesystemCompact.html))

`filesystem_combined`
: Reads data from files on the disk ([documentation](/doc/3.0.0/Nanoc3/DataSources/FilesystemCombined.html))

`filesystem`
: Reads data from files on the disk ([documentation](/doc/3.0.0/Nanoc3/DataSources/Filesystem.html))

`delicious`
: Reads data from [Delicious](http://delicious.com/) ([documentation](/doc/3.0.0/Nanoc3/DataSources/Delicious.html))

`last_fm`
: Reads data from [Last.fm](http://last.fm/) ([documentation](/doc/3.0.0/Nanoc3/DataSources/LastFM.html))

`twitter`
: Reads data from [Twitter](http://twitter.com/) ([documentation](/doc/3.0.0/Nanoc3/DataSources/Twitter.html))

### Writing Custom Data Sources

Data sources are responsible for loading and storing a site’s data: items, layouts and code snippets. They inherit from `Nanoc3::DataSource`. A very useful reference is the ([`Nanoc3::DataSource` source code documentation](/doc/3.0.0/Nanoc3/DataSource.html).

Each data source has an identifier. This is a unique name that is used in a site’s ’s configuration file to specify which data source should be used to fetch data. It is specified like this:

<pre><code class="language-ruby">
class SampleDataSource &lt; Nanoc3::DataSource
  identifier :sample
  # … other code goes here …
end
</code></pre>

All methods in the data source have access to the `@site` object, which represents the site. One useful thing that can be done with this is request the configuration hash, using `@site.config`.

There are two methods you may want to implement first: `#up` and `#down`. `#up` is executed when the data source is loaded. For example, this would be the ideal place to establish a connection to the database. `#down` is executed when the data source is unloaded, so this is the ideal place to undo what `#up` did. You don’t need to implement `#up` or `#down` if you don’t want to.

The `#setup` method is used to create the initial site structure. For example, a database data source could create the necessary tables here. This method is required to be implemented.

You may also want to implement the optional `#update` method, which is used by the `update` command to update the data source to a newer version. This is very useful if the data source changes the way data is stored.

The three main methods in a data source are `#items`, `#layouts` and `#code_snippets`. These load items ([`Nanoc3::Item`](/doc/3.0.0/Nanoc3/Item.html)), layouts ([`Nanoc3::Layout`](/doc/3.0.0/Nanoc3/Layout.html)) and code snippets ([`Nanoc3::CodeSnippet`](/doc/3.0.0/Nanoc3/CodeSnippet.html)), respectively. Implementing these methods is optional, so if you have a data source that only returns items, there’s no need to implement `#layouts` or `#code_snippets`.

If your data source can create items and/or layouts, then `#create_item` and `#create_layout` are methods you will want to implement. These will be used by the `create_site`, `create_item` and `create_layout` commands.

If all this sounds a bit vague, check out the [documentation for `Nanoc3::DataSource`](/doc/3.0.0/Nanoc3/DataSource.html). You may also want to take a look at the code for some of the data sources; the code is well-documented and should help you to get started quickly.
