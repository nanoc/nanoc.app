---

title:                 "Advanced Concepts"
toc_includes_sections: true
markdown:              advanced

---

Writing Helpers
---------------

…

Writing Filters
---------------

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

Writing Data Sources
--------------------

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
