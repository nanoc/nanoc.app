<div style="padding: 10px; background: #fcc; margin: 18px 72px; font-size: 12px; line-height: 18px"><strong style="background: transparent; font-weight: bold; text-transform: uppercase; color: #c00">Warning:</strong> This document currently in the process of being updated for nanoc 3.0. It is at the moment quite incomplete; do not rely on this document to be correct. If you have any questions about nanoc 3.0, find me on the mailinglist or on the IRC channel.</div>

This manual will tell you everything there is to know about nanoc. You may want to read the [Tutorial](/tutorial/) first, especially if you're new to nanoc. You may also want to check out the [source code documentation](/doc/3.0.0/) where all modules, classes, attributes, methods, … are documented—an excellent way to familiarize yourself with nanoc's internals.

Table of Contents
-----------------

<%= toc_for(@item.reps.find { |r| r.name == :notoc }, :base => '') unless @item_rep.name == :notoc %>

The Commandline Tool
--------------------

Interacting with nanoc happens through a commandline tool named `nanoc3`. (The `nanoc` command can only be used for sites built with nanoc 2.x, not 3.x). `nanoc3` has a few sub-commands, which you can invoke like this:

	> nanoc3 [command]

Here, `command` obviously is the name of the command you're invoking. A very useful command is the `help` command, which will give you a detailed description of a given command. You can use it like this:

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

So, if you're ever stuck, consult the the commandline help which (hopefully) will put you back on track.

Sites
-----

A site managed by nanoc is a directory with a specific structure. A site consists of items, layouts, a site configuration and a set of rules.

The way the data in a site is stored depends on the data source that is being used. However, unless you've explicitly told nanoc to use a different data source, the `filesystem_compact` one will be used. This manual assumes that this `filesystem_compact` data source is used. For details, see the [Data Sources](#data-sources) section.

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

The code for custom data sources should be placed in `lib/data_sources`. The code in this directory will be loaded before any other code. (This is necessary, because the data source is responsible for loading code, but it would only be able to load the code for itself once it's loaded.)

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
: The point where this data source's items should be mounted. Defaults to `/`.

`layouts_root`
: The point where this data source's layouts should be mounted. Defaults to `/`.

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

Rules
-----

In order to figure out how to compile an item, nanoc uses processing instructions located in a file called `Rules` which lives at the top level of the nanoc site directory.

The file contains three different kinds of rules: routing rules, compilation rules and layouting rules. Compilation rules determine the actions that should be executed during compilation (filtering, layouting); routing rules determine the path where the compiled files should be written to; layouting rules determine the filter that should be used for a given layout.

A rule consists of a selector, which identifies which items the rule should be applicable to, and an action block (except for layouting rules), which contains the actions to perform.

nanoc will first attempt to build a route for each item. To do so, it will run through all items and find the first matching rule for each item. Only the first matching rule will be used; matching rules that come later will be ignored. Once all items are routed, nanoc will run through all items and find the first matching compilation rule and apply that to the relevant item.

### Routing Rules

A routing rule looks like this:

<% syntax_colorize 'ruby' do %>
	route '/foo/' do
	  # ... routing code here ...
	end
<% end %>

The argument for the `#route` method is the identifier of the item that should
be compiled. It can also be a string that contains the `*` wildcard, which
matches zero or more characters. Additionally, it can be a regular expression.

The code block should return the routed path for the relevant item. The code
block can return nil, in which case the item will not be written.

In the code block, you have access to `rep`, which is the item representation
that is currently being processed, and `item`, which is an alias for
`rep.item`.

Example #1: The following rule will give the item with identifier `/404/` the
path `/error/404.php` (in nanoc 2.2, this would have been done using the
`custom_path` attribute):

<% syntax_colorize 'ruby' do %>
	route '/404/' do
	  '/errors/404.php'
	end
<% end %>

Example #2: The following rule will give all identifiers for which no prior
matching rule exists a path based directly on its identifier (for example, the
item `/foo/bar/` would get the path `/foo/bar/index.html`):

<% syntax_colorize 'ruby' do %>
	route '*' do
	  rep.item.identifier + 'index.html'
	end
<% end %>

Example #3: The following rule will prevent all items with identifiers
starting with '/links/' from being written (the items will still be compiled
so that they can be included in other items, however):

<% syntax_colorize 'ruby' do %>
	route '/link/*' do
	  nil
	end
<% end %>

### Compilation Rules

A compilation rule looks like this:

<% syntax_colorize 'ruby' do %>
	compile '/foo/' do
	  # ... compilation code here ...
	end
<% end %>

The argument for the `#compile` command is exactly the same as the argument
for `#route`; see above for details.

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

<% syntax_colorize 'ruby' do %>
	compile '/sample/one/' do
	end
<% end %>

Example #2: The following rule will filter the rep using the `erb` filter, but
not lay out the rep:

<% syntax_colorize 'ruby' do %>
	compile '/samples/two/' do
	  rep.filter :erb
	end
<% end %>

Example #3: The following rule will filter the rep using the `erb` filter, lay
out the rep using the `shiny` layout, and finally run the laid out rep through
the `rubypants` filter:

<% syntax_colorize 'ruby' do %>
	compile '/samples/three/' do
	  rep.filter :erb
	  rep.layout '/shiny/'
	  rep.filter :rubypants
	end
<% end %>

Example #4: The following rule will filter the rep using the
`relativize_paths` filter with the filter argument `type` equal to `css`:

<% syntax_colorize 'ruby' do %>
	compile '/assets/style/' do
	  rep.filter :relativize_paths, :type => :css
	end
<% end %>

Example #5: The following rule will filter the rep and layout it without
invoking `#filter` or `#layout` with an explicit receiver:

<% syntax_colorize 'ruby' do %>
	compile '/samples/three/' do
	  filter :erb
	  layout '/shiny/'
	  filter :rubypants
	end
<% end %>

### Layouting Rules

To specify the filter used for a layout, use the `#layout` method.

The first argument should be a string containing the identifier of the layout.
It can also be a string that contains the `*` wildcard, which matches zero or
more characters. Additionally, it can be a regular expression.

The second should be the identifier of the filter to use.

In addition to the first two arguments, extra arguments can be supplied; these
will be passed on to the filter.

Example #1: The following rule will make all layouts use the `:erb` filter:

<% syntax_colorize 'ruby' do %>
	layout '*', :erb
<% end %>

Example #2: The following rule will make the default layout use the `haml`
filter and pass a filter argument:

<% syntax_colorize 'ruby' do %>
	layout '/default/', :haml, :format => :html5
<% end %>

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

<% syntax_colorize 'ruby' do %>
	preprocess do
	  # ...
	end
<% end %>

Preprocessors can modify data coming from data sources before it is compiled. It can change item attributes, content and the path, but also add and remove items.

Preprocessors can be used for various purposes. Here are two sample uses:

* A preprocessor could set a `language_code` attribute based on the item path. An item such as `/en/about/` would get an attribute `language_code` equal to `'en'`. This would eliminate the need for helpers such as `language_code_of`.

* A preprocessor could create new (in-memory) items for a given set of items. This is what happens on the nanoc site, where the news archive's pagination pages are created during the preprocessing phase.

### Building the Item Representations

TODO write

### Routing the Item Representations

TODO write

### Compiling the Item Representations

Compiling an item means compiling all of its representations, which in turn involves executing the compilation rules on each representation. After a compilation rule has been applied, the item representation's compiled content will be written to its output file (if it has one) determined by its routing rule.

The following diagram illustrates item compilation by giving a few examples of how items can be filtered and laid out.

<div class="figure">
	<img src="/assets/images/manual/item_compilation_diagram.png" alt="Diagram giving several examples of how items can be filtered and laid out">
</div>

Items that have content dependencies on other items, i.e. items that include the content of another item, will be compiled once the content of the items it depends on is available. Circular content dependencies (item "A" requiring the content of item "B" and vice versa) are detected and reported.

By default, item representations will not be recompiled unless they are outdated. This provides a noticeable speedup, especially for large sites. The `compile` and `autocompile` commands accept a `-f` or `--force` switch, which recompiles items even if they are not outdated.

Items
-----

Items are the basic building blocks of a nanoc-powered site. An item consist of content and metadata attributes.

Items are structured hierarchically. Each item has an identifier that consists of slash-separated parts, which reflects this hierarchy. There is one "root" or "home" page which has path `/`; other items will have paths such as `/journal/2008/some-article/`. The hierarchy of files in the `content` directory reflects this hierarchy.

Item also have a *raw path*, which is where the compiled item will be written to. It is relative to the nanoc site directory and includes the path to the output directory and the terminating "index.html," if any. The *path* of an item is what will be used to link to an item. It is the raw path with the trailing index filenames removed (usually `index.html`). The hierarchy of outputted items does *not* have to be the same as the hierarchy of uncompiled, raw items; see the <a href="#routing">Routing</a> section for details.

### Creating an Item

Item can easily be created manually by simply creating its metadata file and content file. It is often easier to create an item using the commandline, though.

To create an item using the commandline, use `nanoc3 create_item` or `nanoc3 ci`. This command takes one argument: the item identifier. For example, to create an item named "bar" with "foo" as parent item, do this:

	> nanoc3 create_item /foo/bar

### Attributes

Each item has attributes (also called "meta-data") associated with it. This metadata consists of key-value pairs, which are stored in YAML format (although this may vary for different data sources). All attributes are free-form; there are no predefined attributes.

Some filters or helpers may use certain attributes. When using these filters, be sure to check their documentation (see below) to see what attributes they use, if any.

### Representations

TODO write

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
: The item's path relative to the web root, with leading and trailing slashes, e.g. `/news/`.

To get a item representation with a specific name, get the reps by using the `#reps` method and then find the right rep. For example, to get the "raw" representation:

<% syntax_colorize 'ruby' do %>
	raw_rep = @item.reps.find { |r| r.name == :raw }
<% end %>

It is not possible to get the compiled content of an item; items themselves have no compiled content but their reps do. For example, to get the compiled content of a certain item:

<% syntax_colorize 'ruby' do %>
	content = item.reps[0].content_at_snapshot(:pre)
<% end %>

Layouts
-------

On itself, an item's content is not valid HTML yet: it lacks the structure a typical HTML document has. A layout is used to add this missing structure to the item.

For a layout to be useful, it must output the item's content at a certain point. This is done by outputting `yield`. This extremely minimal layout show an example of how this is usually done:

<% syntax_colorize 'html_rails' do %>
	<html>
	  <head>
	    <title><%%=h @item[:title] %></title>
	  </head>
	  <body>
	<%%= yield %>
	  </body>
	</html>
<% end %>

### As Partials

Layouts can also be used as *partials*: a specific layout can be rendered into an item or a layout by using the `render` function, which takes the layout name as an argument. For example:

<% syntax_colorize 'html_rails' do %>
	<%%= render 'head' %>
<% end %>

It is also possible to pass custom variables to rendered partials by putting them into a hash passed to `render`. The following example will make a `@title` variable (set to "Foo" in this example) available in the "head" layout:

<% syntax_colorize 'html_rails' do %>
	<%%= render 'head', :title => 'Foo' %>
<% end %>

Filters
-------

Filters are used for transforming an item's content. For example, the ERB filter interprets the item's content as text with embedded Ruby, executes the embedded Ruby and returns the result.

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
: for [SmartyPants](http://daringfireball.net/projects/smartypants/) (uses [RubyPants](http://chneukirchen.org/news/static/projects/rubypants.html))

`sass`
: for [Sass](http://haml.hamptoncatlin.com/docs/rdoc/classes/Sass.html)

Filter arguments for the `haml` and `sass` filters will be passed to `Haml::Engine.new` and `Sass::Engine.new`, respectively (with the exception of `:filename`, which will be set to the item rep name).

The `relativize_paths` filter makes all paths in HTML or CSS relative. To set the type of data to relativize (HTML or CSS) pass `:type => :html` resp. `:type => :css`. For example, a reference from the `/about/` item to the `/journal/` item will become `../journal/` instead of `/journal/`. This filter uses the <a href="/doc/3.0.0/Nanoc3/Helpers/LinkTo.html">LinkTo helper</a>'s `relative_path_to` function. When using it with HTML, it relativizes all paths in `src=""` and `href=""` attributes; when using it with CSS, it relativizes all paths in `url()` properties.

### Writing Filters

Filters are classes that inherit from `Nanoc3::Filter`. They have one important method, `#run`, which takes the content to filter and a list of parameters, and returns the filtered content. For example:

<% syntax_colorize 'ruby' do %>
	class CensorFilter < Nanoc3::Filter
	  def run(content, params={})
	    content.gsub('nanoc sucks', 'nanoc rocks')
	  end
	end
<% end %>

A filter has an identifier, which is an unique name that is used in calls to `#filter` in a compilation rule. A filter identifier is set using `#identifier`, like this:

<% syntax_colorize 'ruby' do %>
	class CensorFilter < Nanoc3::Filter
	  identifier :censor
	  # ... other code goes here ...
	end
<% end %>

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

<% syntax_colorize 'ruby' do %>
	include Nanoc3::Helpers::Blogging
<% end %>

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
: provides functionality for printing a item's tags (<a href="/doc/3.0.0/Nanoc3/Helpers/Tagging.html">documentation</a>)

`Text`
: provides various text/HTML-related functions (<a href="/doc/3.0.0/Nanoc3/Helpers/Text.html">documentation</a>)

`XMLSitemap`
: provides functionality for creating XML sitemaps (<a href="/doc/3.0.0/Nanoc3/Helpers/XMLSitemap.html">documentation</a>)

Rake Tasks
----------

nanoc comes with a couple of useful built-in rake tasks. To use them, require them in your rakefile, like this:

<% syntax_colorize 'ruby' do %>
	require 'nanoc3/tasks'
<% end %>

The tasks that come with nanoc are:

`clean`
: Removes all files generated by nanoc from the output directory.

`deploy:rsync`
: Deploys the site to a remote server using `rsync`. See below for details.

`validate:css`
: Validates the site's CSS files.

`validate:html`
: Validates the site's HTML files.

Please note that the HTML/CSS validation tasks validate each file by sending it to the W3C validator. Depending on the number of files you have, this may be quite slow.

### rsync Deployment Configuration

In order to use the deploy rake task, the site configuration needs to have deployment configuration. This is the `deploy` hash, which in turn consists of separate hashes that contain each deployment configuration.

Each deployment configuration needs a `dst` key, containing the destination to where should be deployed. It can also contain an optional `options` hash, which is an array of options to pass to rsync.

Here's an example `config.yaml` that shows the deployment configuration:

<% syntax_colorize 'yaml' do %>
	deploy:
	  default:
	    dst:     "myserver:/var/www/mysite"
	    options: [ '-gpPrvz', '--exclude=".svn"' ]
<% end %>

Data Sources
------------

<div style="padding: 10px; background: #fcc; margin: 18px 72px; font-size: 12px; line-height: 18px"><strong style="background: transparent; font-weight: bold; text-transform: uppercase; color: #c00">Warning:</strong> The rest of the document is likely entirely outdated. Peruse at your own risk.</div>

Each site has a *data source*&mdash;a plugin that determines where to read the data for the site from, and where to write new pages and page templates. By default, nanoc uses the filesystem data source, which means pages, layouts, etc. are stored as flat files on disk.

It is not possible to create a site with a specific data source. It is possible, however, to switch an existing site to a new data source. How to do this is specific for each data source, so check out the documentation for the data source you want to switch to.

### Filesystem Data Source

The filesystem data source is the default data source. New nanoc-powered sites automatically use it. This data source does not require any special configuration.

This manual assumes that the filesystem data source is used. The differences between the filesystem and the filesystem-combined data source are listed in the database data source section.

For more information, see the <a href="/doc/3.0.0/Nanoc3/DataSources/Filesystem.html">Filesystem RDoc documentation</a>.

### FilesystemCombined Data Source

The filesystem-combined data source is similar to the filesystem one, except that metadata is stored *inside* the content files, therefore making it unnecessary for pages to be stored in separate directories. This makes the number of files and directories quite a bit lower than with the filesystem data source.
		
The metadata for a page is embedded into the file itself. It is stored at the top of the file, between five dashes. For example:

	-----
	title: Foo
	-----
	h1. Hello!

For more information, see the <a href="/doc/3.0.0/Nanoc3/DataSources/FilesystemCombined.html">FilesystemCombined RDoc documentation</a>.

### Writing Data Sources

A data source is responsible for loading and storing a site's data: pages, page defaults, assets, asset defaults, templates, layouts and code.

Data sources are classes that inherit from `Nanoc::DataSource`. There is no need to explicitly register data source classes; nanoc will find all data source classes automatically.

Each data source has an identifier. This is a unique name that is used in a site's configuration file to specify which data source should be used to fetch data. It is specified like this:

<pre><code><span class="keyword">class</span> <span class="storage">SampleDataSource</span> &lt; <span class="storage">Nanoc::DataSource</span>
  <span class="function">identifier</span> <span class="symbol">:sample</span>
<span class="keyword">end</span></code></pre>

All methods in the data source have access to the `@site` object, which represents the site. One useful thing that can be done with this is request the configuration hash, using `@site.config`.

There are two methods you may want to implement first: `up` and `down`. `up` is executed when the data source is loaded. For example, this would be the ideal place to establish a connection to the database. `down` is executed when the data source is unloaded, so this is the ideal place to undo what `up` did.

The `setup` method is used to create the initial site structure. For example, a database data source could create the necessary tables here. The `destroy` method should do the opposite of what `setup` does. For example, a database data source would drop the created tables in this method.

The `update` method is used for updating the format in which the data is stored. For example, a database data source could add necessary new columns here.

None of these methods need to be implemented; you can simply leave the method definitions out.

The following methods (grouped by data type) are required to be implemented by any data source:

<dl class="nested">
	<dt>Pages &mdash; `Nanoc::Page`</dt>
	<dd>
		<ul>
			<li>`pages()`</li>
			<li>`save_page(page)`</li>
			<li>`move_page(page, new_path)`</li>
			<li>`destroy_page(page)`</li>
		</ul>
	</dd>
	<dt>Page Defaults (singular) &mdash; `Nanoc::PageDefaults`</dt>
	<dd>
		<ul>
			<li>`page_defaults()`</li>
			<li>`save_page_defaults(page_defaults)`</li>
		</ul>
	</dd>
	<dt>Assets &mdash; `Nanoc::Asset`</dt>
	<dd>
		<ul>
			<li>`assets()`</li>
			<li>`save_asset(asset)`</li>
			<li>`move_asset(asset, new_path)`</li>
			<li>`destroy_asset(asset)`</li>
		</ul>
	</dd>
	<dt>Asset Defaults (singular) &mdash; `Nanoc::AssetDefaults`</dt>
	<dd>
		<ul>
			<li>`asset_defaults()`</li>
			<li>`save_asset_defaults(asset_defaults)`</li>
		</ul>
	</dd>
	<dt>Layouts &mdash; `Nanoc::AssetDefaults`</dt>
	<dd>
		<ul>
			<li>`layouts()`</li>
			<li>`save_layout(layout)`</li>
			<li>`move_layout(layout, new_path)`</li>
			<li>`destroy_layout(layout)`</li>
		</ul>
	</dd>
	<dt>Templates &mdash; `Nanoc::Template`</dt>
	<dd>
		<ul>
			<li>`templates()`</li>
			<li>`save_template(template)`</li>
			<li>`move_template(template, new_path)`</li>
			<li>`destroy_template(template)`</li>
		</ul>
	</dd>
	<dt>Code (singular) &mdash; `Nanoc::Code`</dt>
	<dd>
		<ul>
			<li>`code()`</li>
			<li>`save_code(code)`</li>
		</ul>
	</dd>
</dl>

The "singular" indicates that there is only one resource of the specified kind. Such resources therefore lack `move_x` and `destroy_x` functions, as they cannot be moved nor destroyed.

The class name next to each data type is the object type that is passed to functions or is returned from functions. For example, the `save_page` function will get a `Nanoc::Page` while the `layouts` function will return an array of `Nanoc::Layout`s.

The loading functions (`pages`, `page_defaults`, …) should return an array of objects, or, if the resource is singular, a single object. These functions do not take any parameters.

The saving functions (`save_page`, `save_page_defaults`, …) should store the given object. The argument is the object to be stored.

The moving functions (`move_page`, …) should change the given object's name or path. The first argument is the object to be moved, while the second argument is the new path or new name.

The destroying functions (`destroy_page`, …) should delete the given object. The argument is the object to be destroyed.

If all this sounds a bit vague and weird, do check out the source of a data source, and the documentation of `Nanoc::DataSource` itself. The code is well-documented and should help you to get started quickly.
