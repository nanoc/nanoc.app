v3.0.4
------

* Fixed a bug which would cause the filesystem_compact data source to incorrectly determine the content filename, leading to weird “Expected 1 content file but found 3” errors \[Eric Sunshine\]

v3.0.3
------

* The Blogging helper now properly handles item reps without paths
* The relativize_paths filter now only operates inside tags
* The autocompiler now handles escaped paths
* The LinkTo and Tagging helpers now output escaped HTML
* Fixed played_at attribute assignment in Last.fm data source for tracks playing now and added a now_playing attribute \[Nicky Peeters\]
* The filesystem_* data sources can now handle dots in identifiers
* Required `enumerator` to make sure `#enum_with_index` always works
* `Array#stringify_keys` now properly recurses

v3.0.2
------

* Children-only identifier patterns no longer erroneously also match parent (e.g. `/foo/*/` no longer matches `/foo/`)
* The `create_site` command no longer uses those ugly HTML entities
* The install message now mentions the IRC channel

v3.0.1
------

* The proper exception is now raised when no matching compilation rules can be found
* The autocompile command no longer has a duplicate `--port` option
* The `#url_for` and `#feed_url` methods now check the presence of the `base_url` site configuration attribute
* Several outdated URLs are now up-to-date
* Error handling has been improved in general

v3.0
----

### New

* Multiple data sources
* Dependency tracking between items
* Filters can now optionally take arguments
* `create_page` and `create_layout` methods in data sources
* A new way to specify compilation/routing rules using a Rules file
* Coderay filter
* A `filesystem_compact` data source which uses less directories

### Changed

* Pages and textual assets are now known as "items"

### Removed

* Support for drafts
* Support for binary assets
* Support for templates
* Everything that was deprecated in nanoc 2.x
* `save_*`, `move_*` and `delete_*` methods in data sources
* Processing instructions in metadata

v2.2.2
------

* Removed relativize_paths filter; use `relativize_paths_in_html` or `relativize_paths_in_css` instead
* Fixed bug which could cause nanoc to eat massive amounts of memory when an exception occurs
* Fixed bug which would cause nanoc to complain about the open file limit being reached when using a large amount of assets

v2.2.1
------

* Fixed bug which prevented `relative_path_to` from working
* Split `relativize_paths` filter into `relativize_paths_in_html` and `relativize_paths_in_css`
* Removed bundled mime-types library

v2.2
----

### New Features

* `--pages` and `--assets` compiler options
* `--no-color` commandline option
* `Filtering` helper
* `relative_path_to` function in `LinkTo` helper
* `Rainpress` filter
* `RelativizePaths` filter
* The current layout is now accessible through the `@layout` variable
* Much more informative stack traces when something goes wrong

### Changed

* The commandline option parser is now a lot more reliable
* atom_feed now takes optional `:content_proc`, `:excerpt_proc` and `:articles` parameters
* The compile command show non-written items (those with `skip_output: true`)
* The compile command compiles everything by default
* Added `--only-outdated` option to compile only outdated pages

### Removed

* Deprecated extension-based code

v2.1.6
------

* The `FilesystemCombined` data source now supports empty metadata sections
* The RDoc filter now works for both RDoc 1.x and 2.x
* The autocompiler now serves a 500 when an exception occurs outside compilation
* The autocompiler no longer serves index files when the request path does not end with a slash
* The autocompiler now always serves asset content correctly

v2.1.5
------

* Added Ruby 1.9 compatibility
* The `Filesystem` and `FilesystemCombined` data sources now preserve custom extensions

v2.1.4
------

* Fixed an issue where the autocompiler in Windows would serve broken assets

v2.1.3
------

* The Haml and Sass filters now correctly take their options from assets
* Autocompiler now serves index files instead of 404s
* Layouts named "index" are now handled correctly
* `filesystem_combined` now properly handles assets

v2.1.2
------

* Autocompiler now compiles assets as well
* Sass filter now takes options (just like the Haml filter)
* Haml/Sass options are now taken from the page *rep* instead of the page

v2.1.1
------

* Fixed issue which would cause files not to be required in the right order

v2.1
----

For details on the large number of changes in nanoc 2.1, please check the articles in the _What's New in nanoc 2.1_ series in the [news archive](/news/).

### New features

* Asset compilation
* Multiple representations
* Routers
* A better commandline frontend
* New filters: discount, maruku, erubis
* Greatly improved source code documentation
* A new "filesystem_combined" data source
* Page and layout mtimes can now be retrieved through page.mtime or layout.mtime

### Changed

* Layout processors have been merged into filters
* Layouts no longer rely on file extensions
* Already compiled pages won't be recompiled unless changed

### Removed

* Several filters have been replaced by newer ones

v2.0.4
------

* Fixed default.rb's `html_escape`
* Updated Haml filter and layout processor so that `@item`, `@items` and `@config` are now available as instance variables as well as local variables

v2.0.3
------

* Autocompiler now honors custom paths
* Autocompiler now serves files with the correct MIME type

v2.0.2
------

* nanoc now requires Ruby 1.8.5 instead of 1.8.6

v2.0.1
------

* Fixed a "too many open files" error that could appear during (auto)compiling

v2.0
----

For details on the changes in nanoc 2.0, please check the [news archive](/news/) for details.

### New features

* Support for custom layout processors
* Support for custom data sources, as well as a database data source
* Auto-compiler
* `parent` and `children` links for pages

### Changed

* Filters are defined in a different way now
* The 'eruby' filter now uses ERB instead of Erubis
* The source code for nanoc 2.0 has been restructured a great deal
* Templates are no longer run through ERB when creating a page

### Removed

* The `filters` property&mdash;use `filters_pre` instead
* Support for Liquid

v1.6.2
------

* Fixed an issue which prevented the content capturing plugin from working

v1.6.1
------

* Removed a stray debug message

v1.6
----

* Added support for post-layout filters
* Added support for getting a File object for a page, e.g. `@item.file.mtime`
* Cleaned up the source code a lot
* Removed deprecated asset-copying functionality

v1.5
----

* Added support for custom filters
* Improved Liquid support—Liquid is now a first-class nanoc citizen
* Deprecated assets—use something like rsync instead
* Added `eruby_engine` option, which can be `erb` (default) or `erubis`

v1.4
----

* nanoc now supports ERB (as well as Erubis); Erubis no longer is a dependency
* `meta.yaml` can now have `haml_options` property, which is passed to Haml
* Pages can now have a `filename` property, which defaults to "index" \[Dennis Sutch\]
* Page dependencies are now managed automatically \[Dennis Sutch\]

You can safely remove all `order` properties from all meta files, since nanoc now figures page dependencies automatically.

v1.3.1
------

* The contents of the `assets` directory are now copied into the output directory specified in `config.yaml`.

v1.3
----

* The `@items` array now also contains uncompiled pages
* Pages with `skip_output` set to `true` will not be outputted
* Added Textile/RedCloth and Sass filters
* nanoc now warns before overwriting in `create_site`, `create_page` and `create_template`

v1.2
----

* Sites now have an `assets` directory, whose contents are copied to the output directory \[Soryu\]
* Added support for non-eRuby layouts (Markaby, Haml, Liquid)
* Added more filters (Markaby, Haml, Liquid, RDoc \[Dmitry Bilunov\])
* Improved error reporting
* Accessing page attributes using instance variables, and not through `@item`, is no longer possible
* Page attributes can now be accessed using dot notation, i.e. `@item.title` as well as `@item[:title]`

v1.1.3
------

* Fixed bug which would cause pages without layouts to be outputed incorrectly

v1.1.2
------

* Backup files (files ending with a “~”) are now ignored
* Fixed bug which would cause subpages not to be generated correctly

v1.1
----

* Added support for nested layouts
* Added coloured logging
* `@item` now hold the page that is currently being processed
* Index files are now called “content” files and are now named after the directory they are in \[Colin Barrett\]
* It is now possible to access `@item` in the page’s content file

v1.0.1
------

* Fixed a bug which would cause an erroneous “no such template” error to be displayed
* Fixed bug which would cause pages not to be sorted by order before compiling

v1.0
----

* Initial release
