---

title:                 "Advanced Concepts"
toc_includes_sections: true
markdown:              advanced

---

Writing Helpers
---------------

Helpers are modules that can be `include`d to provide additional functionality. The functions in these modules will then be callable from items and layouts. Such helpers need to be located in the `lib/` directory; often, it is a god idea to place them in `lib/helpers/`.

For example, the file `lib/helpers/random_text.rb` could contain this:

<pre title="Defining the RandomTextHelper helper"><code class="language-ruby">
module RandomTextHelper
  def random_text
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end
end
</code></pre>

To allow the `#random_text` method to be called, it can be `include`d. This is often done in `lib/helpers_.rb` (the underscore is necessary to ensure that the file is loaded _after_ the helpers are loaded, which is necessary because files in `lib/` are loaded in alphabetical order). For example:

<pre title="Loading the RandomTextHelper helper"><code class="language-ruby">
include RandomTextHelper
</code></pre>

Now, in an item or layout, the methods provided by this helper can be used. For example, the default layout, assuming it is filtered using ERB, can call the method like this:

<pre title="Calling the random_text method after having loaded the RandomTextHelper helper"><code class="language-html">
&lt;p>&lt;%= random_text %>&lt;/p>
</code></pre>

Writing Filters
---------------

Filters are classes that inherit from `Nanoc3::Filter`. Writing custom filters is done by subclassing said superclass and overriding the `#run` method, which is responsible for transforming the content.

A filter has an identifier, which is an unique name that is used in calls to `#filter` in a compilation rule. A filter identifier is set using `#identifier`, like this:

<pre><code class="language-ruby">
class CensorFilter &lt; Nanoc3::Filter
  identifier :censor

  # … other code goes here …
end
</code></pre>

By default, filters will take textual content as input, and output text as well. Filters can be applied to binary content as well, and they can even tranform text into binary content and vice versa. To identify the type of the input and the output, declare the type in the class, like this:

<pre><code class="language-ruby">
class SampleTextualFilter &lt; Nanoc3::Filter
  identifier :sample_textual
  type :text
  # also possible:
  #   type :text => :text

  # …
end

class SampleBinaryFilter &lt; Nanoc3::Filter
  identifier :sample_binary
  type :binary
  # also possible:
  #   type :binary => :binary

  # …
end

class SampleTextualToBinaryFilter &lt; Nanoc3::Filter
  identifier :sample_textual_to_binary
  type :text => :binary

  # …
end
</code></pre>

The `#run` method looks a bit different for filters that apply to textual items than filters that apply to binary items. Filters that apply to textual items have a `content` argument; a string that contains the content to filter. Filters that apply to binary items, on the other hand, have a `filename` argument instead, containing the location of the file to be filtered. For example:

<pre><code class="language-ruby">
class SampleTextualFilter &lt; Nanoc3::Filter
  identifier :sample_textual
  type :text
  def run(content, params={})
    # …
  end
end

class SampleBinaryFilter &lt; Nanoc3::Filter
  identifier :sample_binary
  type :binary
  def run(filename, params={})
    # …
  end
end
</code></pre>

Filters that output textual content should return the filtered content at the end of the method. Filters that output binary content should instead ensure that the content is written to the location returned by the `#output_filename` method.

Filters have access to `@item`, `@item_rep`, `@items`, `@layouts`, `@config` and `@site`, just like during the compilation process.

Here are trhee complete example of filter that transforms textual and binary content:

<pre><code class="language-ruby">
class CensorFilter &lt; Nanoc3::Filter
  identifier :censor

  def run(content, params={})
    content.gsub('nanoc sucks', 'nanoc rocks')
  end
end

class ResizeFilter &lt; Nanoc3::Filter
  identifier :resize
  type :binary

  def run(filename, params={})
    system(
      'sips',
      '--resampleWidth', params[:width],
      '--out', output_filename,
      filename
    )
  end
end

class SynthesiseAudio &lt; Nanoc3::Filter 
  identifier :synthesise_audio 
  type :text => :binary

  def run(content, params={}) 
    system('say', content, '-o', output_filename)
  end 
end
</code></pre>

When writing filters that apply to binary data, make sure that you check the exit code and any errors generated by the sub-process that you are invoking (if any). If the sub-process exists with an error, you should raise an error in the filter.

Writing Data Sources
--------------------

Data sources are responsible for loading and storing a site’s data: items, layouts and code snippets. They inherit from `Nanoc3::DataSource`. A very useful reference is the ([`Nanoc3::DataSource` source code documentation](/docs/api/3.1/Nanoc3/DataSource.html).

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

The three main methods in a data source are `#items`, `#layouts` and `#code_snippets`. These load items ([`Nanoc3::Item`](/docs/api/3.1/Nanoc3/Item.html)), layouts ([`Nanoc3::Layout`](/docs/api/3.1/Nanoc3/Layout.html)) and code snippets ([`Nanoc3::CodeSnippet`](/docs/api/3.1/Nanoc3/CodeSnippet.html)), respectively. Implementing these methods is optional, so if you have a data source that only returns items, there’s no need to implement `#layouts` or `#code_snippets`.

If your data source can create items and/or layouts, then `#create_item` and `#create_layout` are methods you will want to implement. These will be used by the `create_site`, `create_item` and `create_layout` commands.

If all this sounds a bit vague, check out the [documentation for `Nanoc3::DataSource`](/docs/api/3.1/Nanoc3/DataSource.html). You may also want to take a look at the code for some of the data sources; the code is well-documented and should help you to get started quickly.
