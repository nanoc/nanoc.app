---
title:      "Basics"
markdown:   advanced
has_toc:    true
is_dynamic: true
---

The Commandline Tool
--------------------

Interacting with nanoc happens through a commandline tool named `nanoc`. This tool has a few sub-commands, which you can invoke like this:

<pre title="Executing a nanoc command"><span class="prompt">%</span> <kbd>nanoc</kbd> <var>command</var></pre>

Here, `command` obviously is the name of the command you’re invoking. A very useful command is the `help` command, which will give you a detailed description of a given command. You can use it like this:

<pre title="Getting help on a command"><span class="prompt">%</span> <kbd>nanoc help</kbd> <var>command</var></pre>

For example, this is the help for the `create_site` command:

<pre title="Getting help on the create_site command"><span class="prompt">%</span> <kbd>nanoc help create_site</kbd>
nanoc create_site [path]

aliases: cs

create a site

    Create a new site at the given path. The site will use the compact
    filesystem data source by default, but this can be changed by
    using the --datasource commandline option.

options:

   -d --datasource specify the data source for the new site</pre>

If you want general help, such as a list of available commands and global options, omit the command name, like this:

<pre title="Getting general help for nanoc"><span class="prompt">%</span> <kbd>nanoc help</kbd></pre>

So, if you’re ever stuck, consult the the commandline help which (hopefully) will put you back on track.

Sites
-----

A site managed by nanoc is a directory with a specific structure. A site consists of items, layouts, a site configuration and a set of rules.

The way the data in a site is stored depends on the data source that is being used. However, unless you’ve explicitly told nanoc to use a different data source, the `filesystem_unified` one will be used. This manual assumes that this `filesystem_unified` data source is used. For details, see the [Data Sources](#data-sources) section.

### Creating a Site

To create a site, use the `create_site` command. This command takes the site name as its first and only argument, like this:

<pre title="Creating a site"><span class="prompt">%</span> <kbd>nanoc create_site</kbd> <var>site_name</var></pre>

This will create a directory with the given site name, with a bare-bones directory layout.

### Structure

A site has the following files and directories:

`nanoc.yaml` (on old nanoc sites: `config.yaml`)
: contains the site configuration

`Rules`
: contains compilation, routing and layouting rules

`content/`
: contains the uncompiled items

`layouts/`
: contains the layouts

`lib/`
: contains custom site-specific code (filters, helpers, …)

`output/`
: contains the compiled site

`tmp/`
: contains data used for speeding up compilation (can be safely emptied)

### Code

nanoc will load all Ruby source files in the `lib` directory before it starts compiling. All method definitions, class definitions, etc. will be available during the compilation process. This directory is therefore quite useful for putting in site-wide helpers, filters, data sources, etc.

### Compiling a Site

To compile a site to its final form, the `nanoc compile` (or `nanoc co`) command is used. The compile command is the default command, so it will be invoked if you don’t pass anything. The compile command will write the compiled site to the output directory as specified in the site configuration file. For example:

<pre title="Compiling a site"><span class="prompt">%</span> <kbd>nanoc compile</kbd>
<span class="prompt">%</span> <kbd>nanoc co</kbd>
<span class="prompt">%</span> <kbd>nanoc</kbd></pre>

nanoc will not compile items that are not outdated. If you want to force nanoc to recompile everything, delete the output directory and re-run the compile command.

You can use [guard-nanoc](https://github.com/guard/guard-nanoc) to automatically recompile the site when it changes.

Items
-----

Items are the basic building blocks of a nanoc-powered site. An item consist of content and metadata attributes.

Items are structured hierarchically. Each item has an identifier that consists of slash-separated parts, which reflects this hierarchy. There is one “root” or “home” page which has identifier `/`; other items will have identifiers such as `/journal/2008/some-article/`. The hierarchy of files in the `content` directory reflects this hierarchy.

Items can be textual or binary. If the extension of the item is included in the site configuration’s `text_extension` array, it is considered to be textual; otherwise, it will be binary. Site assets such as images, audio files and movies should be binary. Binary items don’t have their content stored in-memory. Instead, binary items have a filename pointing to the file containing the content.

To get the raw, uncompiled content of a (textual) item, use [`Nanoc::Item#raw_content`](/docs/api/Nanoc/Item.html#raw_content-instance_method). To get the compiled content, use [`Nanoc::Item#compiled_content`](/docs/api/Nanoc/Item.html#compiled_content-instance_method). The latter method has a `:rep` option for specifying the rep to get the compiled content from, and a `:snapshot` option for specifying the name of the snapshot to fetch. For details, see the [Representations](#representations) and [Snapshots](#snapshots) sections below. It is not possible to request the content of binary items.

The default list of text extensions is the following:

<pre><code class="language-yaml">
text_extensions: [ <%= Nanoc::Site::DEFAULT_CONFIG[:text_extensions].map { |i| "'#{i}'" }.join(', ') %> ]
</code></pre>

To get the path of the compiled item, use [`Nanoc::Item#path`](/docs/api/Nanoc/Item.html#path-instance_method). This path is relative to the output directory; it starts with a slash which indicates the web root, i.e. the output directory. The index filenames are stripped off the end of the path. You can pass a `:rep` option to get the path of a specific representation. For example, the path of an item that is compiled to `output/foo/index.html` is `/foo/`.

During compilation, items cannot be modified. You can, however, adjust the item content and attributes in the preprocessor.

### Creating an Item

Items are stored as plaintext files on the hard drive (unless you’re using esoteric data sources), so it’s easy to manually create items. nanoc provides a `create_item` (or `ci`) command for making item generation easier, though. This command looks like this:

<pre title="Creating an item"><span class="prompt">%</span> <kbd>nanoc create_item</kbd> <var>item_identifier</var></pre>

### Attributes

Each item has attributes (metadata) associated with it. This metadata consists of key-value pairs, which are stored in YAML format (although this may vary for different data sources). All attributes are free-form; there are no predefined attributes.

To get an item attribute, use the [`Nanoc::Item#[]`](/docs/api/Nanoc/Item.html#%5B%5D-instance_method) method and pass the attribute key as a symbol, e.g. `@item[:author]`.

Some filters or helpers may use certain attributes. When using such filters or helpers, be sure to check their documentation (see below) to see what attributes they use, if any.

When using a filesystem-based data source, attributes are stored as YAML in either the top of the file representing the item, or a separate file with the same base name. For example, an item at `content/about.html` could look like this when the metadata is embedded into the file:

<pre title="Item with embedded metadata"><code class="language-yaml">---
title: "Some Page"
---</code>

<code class="language-html">&lt;p>Lorem ipsum dolor sit amet…&lt;/p></code></pre>

If you are using the default data source (`filesystem_unified`), then each item will automatically receive some extra attributes that may be useful. These are:

`:filename`
: the name of the file corresponding to the item (if there is only one file that contains both content and metadata)

`:content_filename`
: the name of the content file (if there is a content file)

`:meta_filename`
: the name of the meta-file (if there is a meta-file)

`:extension`
: the extension of the file or the content file (if there is one, because it is possible to have a meta-file without a corresponding content file)

### Representations

An item representation (or “rep” for short) is a compiled version of an item. Each representation has a name (a symbol, not a string). An item can have multiple representations, though usually it will have just one (named `default`).

Multiple representations are useful when items need to be available in multiple formats. For example, HTML and XHTML. You could also have a `raw` representation that isn’t compiled at all—just the raw, unfiltered, non-laid out content. Sometimes, it may even be useful to have XML, YAML or JSON representations of an item.

An item’s list of representation can be fetched by calling [`Nanoc::Item#reps`](/docs/api/Nanoc/Item.html#reps-instance_method) instance. To get a specific rep, use [`Nanoc::Item#rep_named`](/docs/api/Nanoc/Item.html#rep_named-instance_method) with the rep name, like this:

<pre title="Finding the item rep with the given name"><code class="language-ruby">
rep = @item.rep_named(:default)
</code></pre>

### Snapshots

A snapshot is the compiled content at a specific point during the compilation process. Snapshots can be generated manually, but some snapshots are generated automatically (see below).

To get the compiled content of a specific snapshot, use the `:snapshot` option of [`Nanoc::Item#compiled_content`](/docs/api/Nanoc/Item.html#compiled_content-instance_method) or [`Nanoc::ItemRep#compiled_content`](/docs/api/Nanoc/ItemRep.html#compiled_content-instance_method). For example:

<pre title="Getting the compiled content at a certain snapshot"><code class="language-ruby">
stuff = some_item.compiled_content(:snapshot => :pre)
stuff = some_rep.compiled_content(:snapshot => :last)
</code></pre>

The following snapshots are generated automatically:

`:raw`
: The content right before actual compilation is started

`:pre`
: The content right before the item is laid out

`:post`
: The content after the item has been laid out and post-filtered

`:last`
: The most recent compiled content

The `:post` and `:last` snapshots will usually be the same. The difference is that `:last` is a moving snapshot: it always refers to the last compiled content. `:last` may refer to `:raw` or `:pre` early on, but may point to `:post` later. Also, there will _always_ be a `:last` snapshot but not necessary a `:post` snapshot; items that are not laid out will not have one.

Binary items cannot have snapshots.

Layouts
-------

On itself, an item’s content is not valid HTML yet: it lacks the structure a typical HTML document has. A layout is used to add this missing structure to the item.

For a layout to be useful, it must output the item’s content at a certain point. This is done by outputting `yield`. This extremely minimal layout shows an example of how this is usually done:

<pre title="A minimalistic layout"><code class="language-html">&lt;html>
  &lt;head>
    &lt;title>&lt;%=h @item[:title] %>&lt;/title>
  &lt;/head>
  &lt;body>
    &lt;%= yield %>
  &lt;/body>
&lt;/html></code></pre>

An item is put into a layout by calling the `layout` function in a compilation rule. See the [Compilation Rules](#compilation-rules) section for details.

During compilation, layouts cannot be modified. You can, however, adjust the layout content and attributes in the preprocessor.

### As Partials

Layouts can also be used as *partials*: a specific layout can be rendered into an item or a layout by using the `render` function, which takes the layout name as an argument. For example:

<pre title="Rendering the “head” layout as a partial"><code class="language-html">&lt;%= render 'head' %></code></pre>

To use this helper, activate the [Rendering](/docs/reference/helpers/#rendering) helper (see the [helpers](#helpers) section for details), which is done by adding this line of code to some file in the `lib` directory (I recommend `lib/helpers.rb`):

<pre title="Activating the Rendering helper"><code class="language-ruby">include Nanoc::Helpers::Rendering</code></pre>

It is also possible to pass custom variables to rendered partials by putting them into a hash passed to `#render`. The following example will make a `@title` variable (set to `"Foo"` in this example) available in the `head` layout:

<pre title="Rendering the “head” partial with custom variables"><code class="language-html">&lt;%= render "head", :title => "Foo" %></code></pre>

Rules
-----

The instructions for processing items are located in a file named `Rules` which lives in a nanoc site directory. This rules file contains _routing rules_, _compilation rules_ and _layouting rules_. Compilation rules determine the actions that should be executed during compilation (filtering, layouting), routing rules determine the path where the compiled files should be written to, and layouting rules determine the filter that should be used for a given layout.

Full documentation on the Rules file is available in the <%= link_to 'Rules reference', @items['/docs/reference/rules/'] %>.

The Compilation Process
-----------------------

Compiling a site involves several steps:

1. Loading the site data
2. Preprocessing the site data
3. Building the item representations
4. Routing the item representations
5. Compiling the item representations

### Loading the Site Data

Before compilation starts, data for items and layouts will be read from all data sources, and mounted at the roots specified by the data sources. For more information about data sources, see the [Data Sources](#data-sources) section.

### Preprocessing the Site Data

After the data is loaded, it is _preprocessed_ if a preprocessor block exists. A preprocessor block is a simple piece of code defined in the `Rules` file that will be executed after the data is loaded. It looks like this:

<pre title="A sample preprocessor block"><code class="language-ruby">
preprocess do
  # (preprocessing code here)
end
</code></pre>

Preprocessors can modify data coming from data sources before it is compiled. It can change item attributes, content and the path, but also add and remove items.

Preprocessors can be used for various purposes. Here are two sample uses:

* A preprocessor could set a `language_code` attribute based on the item path. An item such as `/en/about/` would get an attribute `language_code` equal to `'en'`. This would eliminate the need for helpers such as `language_code_of`.

* A preprocessor could create new (in-memory) items for a given set of items. This can be useful for creating pages that contain paginated items.

### Building the Item Representations

Once the data is loaded and preprocessed, item representations are built for each item. For each item, its compilation rules (one per item representation) are looked up and a rep is built for each rule.

For example, the following code will cause the item `/foo/` to have only one rep (`default`), while the item `/bar/` will have two reps (`raw` and `full`):

<pre title="A sample Rules file with compilation rules for different representations"><code class="language-ruby">compile '/foo/' do
  # (compilation code for the default rep here)
end

compile '/bar/', :rep => :raw do
  # (compilation code for the :raw rep here)
end

compile '/bar/', :rep => :full do
  # (compilation code for the :full rep here)
end</code></pre>

### Routing the Item Representations

For each item representation, the matching routing rule is looked up and applied to the item rep. The item rep’s path to the output file will be set to the return value of the routing rule block.

The routing rule block can also return nil, in which case the item representation will not be written to the disk—useful when items should be included as part of other, larger items, but should not exist separately.

For example, the following code will cause the item `/foo/` to be written to `output/abc.html`, while the `/bar/` item will be written to `output/xyz.css`, and the item `/qux/` will not be written at all:

<pre title="A sample Rules file where items are routed to specific locations"><code class="language-ruby">route '/foo/' do
  '/abc.html'
end

route '/bar/' do
  '/xyz.css'
end

route '/qux/' do
  nil
end</code></pre>

### Compiling the Item Representations

Compiling an item means compiling all of its representations, which in turn involves executing the compilation rules on each representation. After a compilation rule has been applied, the item representation’s compiled content will be written to its output file (if it has one) determined by its routing rule.

The following diagram illustrates item compilation by giving a few examples of how items can be filtered and laid out.

<div class="figure">
	<img src="/assets/images/manual/item_compilation_diagram.png" alt="Diagram giving several examples of how items can be filtered and laid out">
</div>

Items that have content dependencies on other items, i.e. items that include the content of another item, will be compiled once the content of the items it depends on is available. Circular content dependencies (item "A" requiring the content of item "B" and vice versa) are detected and reported.

Filters
-------

Filters are used for transforming an item’s content. For example, the ERB filter interprets the item’s content as text with embedded Ruby, executes the embedded Ruby and returns the result. Each filter has an identifier (a symbol), which is used in the call to `#filter` in a compilation rule.

Filters can be applied to binary items as well. For example, thumbnail generation for a gallery page can be handled by nanoc. Filters can also convert textual content into binary files and vice versa; text-to-speech filters and OCR filters are therefore possible (but perhaps not very useful).

nanoc comes with quite a handful of filters. Check out the [filters reference](/docs/reference/filters/) for a list of filters bundled with nanoc.

Helpers
-------

A helper is a module with useful functions that can be used in items and layouts.

Helpers need to be activated before they can be used. To activate a helper, `include` it, like this (in a file in the `lib` directory, such as `lib/helpers.rb`):

<pre title="Activating the Blogging helper by #include’ing it"><code class="language-ruby">
include Nanoc::Helpers::Blogging
</code></pre>

Take a look at the [helpers reference](/docs/reference/helpers/) for a list of helpers that are included with nanoc.

Data Sources
------------

Each site has one or more _data sources_: objects that can load site data (items and layouts) from certain locations, and even create new items and layouts.

New nanoc sites will have only one data source: the `filesystem_unified` one. For details about this data source, see the [documentation for `FilesystemUnified`](/docs/api/Nanoc/DataSources/FilesystemUnified.html).

The site configuration has a list of hashes containing the data source configurations. Each list item is a hash with the following keys:

`type`
: The identifier of data source to use (`filesystem_unified`, `filesystem_verbose`…)

`items_root`
: The root where items should be mounted. Optional; defaults to `/`.

`layouts_root`
: The root where layouts should be mounted. Optional; defaults to `/`.

`config`
: A hash containing custom configuration options for the data source. The contents of this hash depends on the data source used; see the documentation of the data source for details.

For example, the configuration of a site that uses many data sources could look like this:

<pre title="A site configuration with multiple data sourcs"><code class="language-yaml">data_sources:
  -
    # This data source simply loads data from the filesystem.
    type:       'filesystem_unified'
  -
    # This data source loads events as items from a calendar application
    # and stores the loaded items under /events.
    type:       'calendar'
    items_root: '/events'</code></pre>

nanoc comes bundled with the following two data sources:

[`filesystem_unified`](/docs/api/Nanoc/DataSources/FilesystemUnified.html)
: Reads data from files on the disk. It is the default data source for new sites.

[`filesystem_verbose`](/docs/api/Nanoc/DataSources/FilesystemVerbose.html)
: Reads data from files on the disk. Older versions of nanoc used this data source as the default one.
