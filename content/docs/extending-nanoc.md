---
title:    "Extending nanoc"
has_toc:  true
markdown: advanced
is_dynamic: true
---

Writing Helpers
---------------

Helpers are modules that can be `include`d to provide additional functionality. The functions in these modules will then be callable from items and layouts. Such helpers need to be located in the `lib/` directory; often, it is a good idea to place them in `lib/helpers/`.

For example, the file `lib/helpers/random_text.rb` could contain this:

<pre title="Defining the RandomTextHelper helper"><code class="language-ruby">module RandomTextHelper
  def random_text
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end
end
</code></pre>

To allow the `#random_text` method to be called, it can be `include`d. This is often done in `lib/helpers_.rb` (the underscore is necessary to ensure that the file is loaded _after_ the helpers are loaded, which is necessary because files in `lib/` are loaded in alphabetical order). For example:

<pre title="Loading the RandomTextHelper helper"><code class="language-ruby">include RandomTextHelper
</code></pre>

Now, in an item or layout, the methods provided by this helper can be used. For example, the default layout, assuming it is filtered using ERB, can call the method like this:

<pre title="Calling the random_text method after having loaded the RandomTextHelper helper"><code class="language-html">&lt;p>&lt;%= random_text %>&lt;/p>
</code></pre>

Writing Filters
---------------

Filters are classes that inherit from `Nanoc::Filter`. Writing custom filters is done by subclassing said superclass and overriding the `#run` method, which is responsible for transforming the content.

A filter has an identifier, which is an unique name that is used in calls to `#filter` in a compilation rule. A filter identifier is set using `#identifier`, like this:

<pre><code class="language-ruby">class CensorFilter &lt; Nanoc::Filter
  identifier :censor

  # (other code here)
end
</code></pre>

By default, filters will take textual content as input, and output text as well. Filters can be applied to binary content as well, and they can even tranform text into binary content and vice versa. To identify the type of the input and the output, declare the type in the class, like this:

<pre><code class="language-ruby">class SampleTextualFilter &lt; Nanoc::Filter
  identifier :sample_textual
  type :text
  # also possible:
  #   type :text => :text

  # (other code here)
end

class SampleBinaryFilter &lt; Nanoc::Filter
  identifier :sample_binary
  type :binary
  # also possible:
  #   type :binary => :binary

  # (other code here)
end

class SampleTextualToBinaryFilter &lt; Nanoc::Filter
  identifier :sample_textual_to_binary
  type :text => :binary

  # (other code here)
end
</code></pre>

The `#run` method looks a bit different for filters that apply to textual items than filters that apply to binary items. Filters that apply to textual items have a `content` argument; a string that contains the content to filter. Filters that apply to binary items, on the other hand, have a `filename` argument instead, containing the location of the file to be filtered. For example:

<pre><code class="language-ruby">class SampleTextualFilter &lt; Nanoc::Filter
  identifier :sample_textual
  type :text
  def run(content, params={})
    # (filter code here)
  end
end

class SampleBinaryFilter &lt; Nanoc::Filter
  identifier :sample_binary
  type :binary
  def run(filename, params={})
    # (filter code here)
  end
end
</code></pre>

Filters that output textual content should return the filtered content at the end of the method. Filters that output binary content should instead ensure that the content is written to the location returned by the `#output_filename` method.

Filters have access to `@item`, `@item_rep`, `@items`, `@layouts`, `@config` and `@site`, just like during the compilation process.

Here are three complete examples of filters that transform textual and binary content:

<pre><code class="language-ruby">class CensorFilter &lt; Nanoc::Filter
  identifier :censor

  def run(content, params={})
    content.gsub('nanoc sucks', 'nanoc rocks')
  end
end

class ResizeFilter &lt; Nanoc::Filter
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

class SynthesiseAudio &lt; Nanoc::Filter 
  identifier :synthesise_audio 
  type :text => :binary

  def run(content, params={}) 
    system('say', content, '-o', output_filename)
  end 
end
</code></pre>

When writing filters that apply to binary data, make sure that you check the exit code and any errors generated by the sub-process that you are invoking (if any). If the sub-process exists with an error, you should raise an error in the filter.

Writing Commands
----------------

As of nanoc 3.2, it is possible to write custom commands. Create a `commands/` directory in your site directory and drop your commands there. A command is defined using a DSL and looks something like this:

	#!ruby
	usage       'dostuff [options]'
	aliases     :ds, :stuff
	summary     'does stuff'
	description 'This command does a lot of stuff. I really mean a lot.'
    
	flag   :h, :help,  'show help for this command' do |value, cmd|
	  puts cmd.help
	  exit 0
	end
	flag   :m, :more,  'do even more stuff'
	option :s, :stuff, 'specify stuff to do', :argument => :optional
    
	run do |opts, args, cmd|
	  stuff = opts[:stuff] || 'generic stuff'
	  puts "Doing #{stuff}!"
    
	  if opts[:more]
	    puts 'Doing it even more!'
	  end
	end

The name of the command is derived from the filename. For example, a command defined in `commands/dostuff.rb` will have the name `dostuff` and to invoke it you’d type “nanoc dostuff”. You can have nested commands by defining subcommands in subdirectories. For example, the command at `commands/foo/bar.rb` will be a subcommand of the command at `commands/foo.rb`.

For details on how to create such commands, check out the documentation for [Cri](http://rubydoc.info/gems/cri/2.0.0/file/README.md), the framework used by nanoc for generating commands.

Writing Data Sources
--------------------

Data sources are responsible for loading and storing a site’s data: items, layouts and code snippets. They inherit from `Nanoc::DataSource`. A very useful reference is the [`Nanoc::DataSource` source code documentation](<%= api_doc_root %>Nanoc/DataSource.html).

Each data source has an identifier. This is a unique name that is used in a site’s ’s configuration file to specify which data source should be used to fetch data. It is specified like this:

<pre><code class="language-ruby">class SampleDataSource &lt; Nanoc::DataSource
  identifier :sample
  # (other code here)
end
</code></pre>

All methods in the data source have access to the `@site` object, which represents the site. One useful thing that can be done with this is request the configuration hash, using `@site.config`.

There are two methods you may want to implement first: `#up` and `#down`. `#up` is executed when the data source is loaded. For example, this would be the ideal place to establish a connection to the database. `#down` is executed when the data source is unloaded, so this is the ideal place to undo what `#up` did. You don’t need to implement `#up` or `#down` if you don’t want to.

The `#setup` method is used to create the initial site structure. For example, a database data source could create the necessary tables here. This method is required to be implemented.

You may also want to implement the optional `#update` method, which is used by the `update` command to update the data source to a newer version. This is very useful if the data source changes the way data is stored.

The two main methods in a data source are `#items` and `#layouts`. These load items ([`Nanoc::Item`](<%= api_doc_root %>Nanoc/Item.html)) and layouts ([`Nanoc::Layout`](<%= api_doc_root %>Nanoc/Layout.html)) respectively. Implementing these methods is optional, so if you e.g. have a data source that only returns items, there’s no need to implement `#layouts`.

If your data source can create items and/or layouts, then `#create_item` and `#create_layout` are methods you will want to implement. These will be used by the `create_site`, `create_item` and `create_layout` commands.

If all this sounds a bit vague, check out the [documentation for `Nanoc::DataSource`](<%= api_doc_root %>Nanoc/DataSource.html). You may also want to take a look at the code for some of the data sources; the code is well-documented and should help you to get started quickly.
