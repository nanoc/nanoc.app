---

title:      "Migrating to nanoc 3.0"
markdown:   advanced
is_dynamic: true

---

nanoc 3.0 is quite different from nanoc 2.2 in several ways. It is not
backward compatible, which means that it is not possible to compile a nanoc
2.2 site out of the box. This document is meant to be a guide through the
steps necessary to convert a nanoc 2.2 site to a nanoc 3.0 one.

Name changes
------------

The nanoc 3.0 commandline tool is called `nanoc3` and not `nanoc`. Therefore,
e.g. compiling a nanoc 3.0 site is done using `nanoc3 co`. The old `nanoc`
commandline tool cannot be used with nanoc 3.0 sites.

nanoc 3.0 uses a new namespace, `Nanoc3`, instead of the old `Nanoc`
namespace. Any custom code that lives in the `Nanoc` namespace should
therefore be moved into the new `Nanoc3` namespace.

The `Render` helper has, for consistency's sake, been renamed to `Rendering`.

Dropped Features
----------------

Several features present in nanoc 2.2 are no longer supported in nanoc 3.0.
These include:

* Support for binary assets
* Support for drafts
* Support for templates
* `save_*`, `delete_*`, `move_*` methods in data sources
* Old-style routers (replaced with routing rules---see below for details)
* Page and asset defaults

Items versus Pages and Assets
-----------------------------

Pages and textual assets have been merged and are now known simply as "items."
This means that all operations on pages can now be applied to textual assets
as well (such as laying out an asset, which was not possible before). Binary
assets are no longer supported.

Paths versus identifiers
------------------------

The _identifier_ of an item is a path starting with a slash and ending with a
slash. It is not necessarily the path that will be used when linking to this
item.

The _path_ of an item representation is the path that will be used when
linking to the item. It can be identical to the identifier, but it does not
have to be. The path does not include any trailing index file names (as
specified in the site configuration).

The _raw path_ of an item representation is the path, relative to the current
working directory, to the output file. It includes the path to the output
directory and it also includes the trailing index filename (if any).

Since items themselves are not written (their representations are), items do
not have a path. It is not possible to link to an item, but it is possible to
link to a representation; i.e. do not use `@item.path` but use
`@item.reps[0].path`.

Accessing attributes
--------------------

Accessing item attributes is now done using the `#[]` method (e.g.
`@item[:title]`). It is no longer possible to use "dot notation" to request
attributes (e.g. `@item.title` will not work).

Site Configuration versus Page Defaults
---------------------------------------

Some helper, such as the `XMLSitemap` and the `Blogging` one, will now take
their configuration from the site configuration file (`config.yaml`) instead
of the page defaults. Consult the documentation for these helpers for details.

Item Content
------------

It is not possible to get the compiled content of an item; only the compiled
content of an item _representation_ can be fetched. `Nanoc3::ItemRep` has a
method `#content_at_snapshot` which returns the content at the given snapshot.
If you want the raw, uncompiled content, pass `:raw` as an argument for
`#content_at_snapshot`; if you want the compiled but not yet laid out content,
pass `:pre`; if you want the full compiled and laid out content, pass `:post`.

nanoc 3.0 layouts should use `yield` to insert the content of the item. It is
possible to use `@item_rep.content_at_snapshot(:pre)` instead of yielding, but
this is not recommended.

Dates and Times
---------------

nanoc 3.0 does not automatically convert attributes ending with `_on` or `_at`
to `Date` and `Time` instances, respectively.

Filter Arguments
----------------

Filters can now take a hash of arguments. The signature of a filter's `#run`
method has changed: instead of taking only one option (the content), it takes
two: the content and a hash of arguments. For example:

<pre><code class="language-ruby">
class MyNanoc3Filter &lt; Nanoc3::Filter
  def run(content, arguments={})
    # ... code goes here ...
  end
end
</code></pre>

LinkTo Helper and Reps
----------------------

The `#link_to` function now expects an item rep, not an item.

Data Sources
------------

nanoc 3.0 supports multiple data sources, and the configuration for data
sources has changed to reflect this new feature. The site configuration now
has an array named `data_sources` which contains a list of hashes describing
the data source.

This hash has a `type` attribute containing the identifier of the data source
to use (e.g. `filesystem`). It also has `items_root` and `layouts_root`
attributes, which contains the root at which items should be mounted and the
root at which layouts should be mounted, respectively (similar to mount points
in Unix-like OSes). Finally, the `config` attribute is a hash containing
custom configuration attributes (such as usernames for a data source that
requires authentication).

Example #1: This data source configuration is the default configuration which
contains only a single data source (the filesystem one) mounted at /:

<pre><code class="language-yaml">
data_sources:
  -
    type:         'filesystem'
    items_root:   '/'
    layouts_root: '/'
</code></pre>

Example #2: This data source configuration contains multiple data sources
(filesystem, twitter, delicious) mounted at different paths:

<pre><code class="language-yaml">
data_sources:
  -
    type:         'filesystem'
    items_root:   '/'
    layouts_root: '/'
  -
    type:         'twitter'
    items_root:   '/tweets'
    # no layouts_root because twitter does not provide layouts
    config:
      username: 'ddfreyne'
  -
    type:       'delicious'
    items_root: '/links'
    # no layouts_root because delicious does not provide layouts
    config:
      username: 'ddfreyne'
</code></pre>

FilesystemCompact data source
-----------------------------

nanoc 3.0 comes with a new data source based on the original filesystem data
source, but uses less directories. For example, this is a small part of the
directory structure used by the Stoneship site:

	content/
	  index.html
	  index.yaml
	  about.html
	  about.yaml
	  journal.html
	  journal.yaml
	  journal/
	    2005.html
	    2005.yaml
	    2005/
	      a-very-old-post.html
	      a-very-old-post.yaml
	      another-very-old-post.html
	      another-very-old-post.yaml
	  myst/
	    index.html
	    index.yaml

A script to convert from the old `filesystem` to the new `filesystem_compact`
data source is available here:

	 http://nanoc.stoneship.org/pub/update_to_filesystem_compact.txt

To use this script, rename the extension to .rb and then edit the script and
define the `command` variable that contains the command that will be used to
move files. Then just invoke it. After running it, be sure to edit the site
configuration and change the data source to `filesystem_compact`.

Rules
-----

nanoc 3.0 does not use attributes in metadata files (the `.yaml` files) in
order to figure out how to compile an item. Instead, processing instructions
are located in a new file called `Rules` which lives at the top level of the
nanoc site directory. See the [Rules section](/manual/#rules) of the manual
for details.
