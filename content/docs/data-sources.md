---
title: "Data sources"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

<span class="firstterm">Data sources</span> provide items and layouts. A nanoc site has one or more data sources. By default, a site uses the [filesystem data source](#the-filesystem-data-source).

The site configuration contains the configurations for each used data source. For example, this is the data source configuration for the nanoc.ws web site:

    #!yaml
    data_sources:
      -
        type: filesystem_unified
        identifier_style: full
      -
        type: cli
        items_root: /docs/reference/commands/
        identifier_style: full

The data source configuration is a list of hashes. Each hash can have the following keys:

`type`
: The identifier of data source to use

`items_root`
: The root where items should be mounted (optional)

`layouts_root`
: The root where layouts should be mounted (optional)

The `items_root` and `layouts_root` values will be prefixed to the identifiers of any items and layouts, respectively, obtained from this data source. For example, a data source might provide an item with identifier `/denis.md`, which, when the `items_root` is set to `/people`, will become `/people/denis.md`.

The filesystem data source
--------------------------

nanoc comes with a _filesystem_ data source implementation, which, as the name suggests, loads items and layouts from the filesystem. More specifically, it loads items from the <span class="filename">content/</span> directory, and layouts from the <span class="filename">layouts/</span> directory.

<pre><span class="prompt">%</span> <kbd>tree content</kbd>
content
├── 404.html
├── about.md
├── assets
│   └── style
│       ├── print.scss
│       └── screen.scss
├── community.md
├── contributing.md
└── index.md</pre>

<pre><span class="prompt">%</span> <kbd>tree layouts</kbd>
layouts
├── article.erb
├── default.erb
└── home.erb</pre>

The attributes for an item or a layout are typically stored in the metadata section or frontmatter, inside the file itself. The metadata is contained within a pair of triple dashes, like this:

    #!yaml
    ---
    full_title: "nanoc: a static site generator written in Ruby > home"
    short_title: "Home"
    has_raw_layout: true
    ---

    Main content goes here…

Attributes can also be stored in a separate file with the same base name but with the `.yaml` extension.. This is necessary for binary items. For example, the following two files correspond to a single item; the metadata is stored in the YAML file:

<pre><span class="prompt">%</span> <kbd>tree content/assets/images</kbd>
images
├── dataflow.png
└── dataflow.yaml</pre>

The identifier of items and layouts are obtained by taking the filename and stripping off everything up until the content or layouts directory, respectively. For example, the <span class="filename">/Users/denis/stoneship/content/about.md</span> file will have the identifier _/about.md_.

### Configuration

    #!yaml
    content_dir: content
    layouts_dir: layouts
    encoding: utf-8

The `content_dir` option contains the path to the directory where the content is stored. By default, it is <span class="filename">content</span>.

The `layouts_dir` option contains the path to the directory where the layouts are stored. By default, it is <span class="filename">layouts</span>.

The `encoding` option sets the encoding used for reading files. It should be a value understood by Ruby’s `Encoding`. If no encoding is set in the configuration, one will be inferred from the environment.

NOTE: Because inferring the encoding from the environment is so unreliable, the final version of nanoc 4 might default to UTF-8.

Writing data sources
--------------------

Here is an example data source implementation that provides a single item with the identifier `/release-notes.md` and containing the content of the <span class="filename">NEWS.md</span> file of nanoc:

    #!ruby
    class ReleaseNotesDataSource < Nanoc::DataSource
      identifier :release_notes

      def items
        gem_path = Bundler.rubygems.find_name('nanoc').first.full_gem_path
        content = File.read("#{gem_path}/NEWS.md")

        item = new_item(
          content,
          title: 'Release notes',
          Nanoc::Identifier.new('/release-notes.md'),
        )

        [item]
      end
    end

Each data source has an identifier. This identifier is used in the configuration file to specify which data source should be used to fetch data. In the example above, the identifier is `release_notes`.

The `#items` and `#layouts` methods return a collection of items and layouts, respectively. To instantiate items and layouts, use `#new_item` and `#new_layout`, respectively. These methods take three arguments:

`content_or_filename`
: The content of the item or layout, or a filename if the item is a binary item.

`attributes`
: A hash with attributes of this item or layout.

`identifier`
: A `Nanoc::Identifier` instance, or a string that will be converted to an identifier. See the <%= link_to_id('/docs/reference/identifiers-and-patterns.*') %> page for details.

To create a binary item, also pass `binary: true` to the `#new_item` method.

The configuration for this data source is available in `@config`.

If a data source needs to do work before data becomes available, such as establishing a connection, it can do so in the `#up` method. The `#down` method can be used to undo the work, such as tearing down the connection. Here is an example data source that reads from a SQLite database:

    #!ruby
    class HRDataSource < ::Nanoc::DataSource
      identifier :hr

      def up
        @db = Sequel.sqlite('employees.db')
      end

      def down
        @db.disconnect
      end

      def items
        @db[:employees].map do |row|
          new_item(
            row[:bio],
            row,
            "/employees/#{row[:id]}/"
          )
        end
      end
    end

See the <%= link_to_id('/docs/guides/using-external-sources.*') %> page for more information on using external data sources such as databases.
