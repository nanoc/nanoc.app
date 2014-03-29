---
title: "Tutorial"
---

This is a small nanoc tutorial that should take about twenty minutes to complete. You need three basic things in order to follow the tutorial:

a working nanoc installation
: Check out the [Install](/install/) page for details on how to install Ruby, Rubygems and nanoc.

a basic understanding of Ruby
: nanoc uses the Ruby programming language quite extensively. If you are unfamiliar with Ruby, we recommend [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/).

a basic understanding of the command line
: nanoc is executed on the command line. If you need to brush up on your command line skills, we recommend [The Command Line Crash Course](http://cli.learncodethehardway.org/).

Create a site
-------------

To create a new site, use the <kbd>create-site</kbd> command, followed by the name of the new directory in which you want nanoc to create a site. Let’s create a `tutorial` site:

<pre><span class="prompt">%</span> <kbd>nanoc create-site tutorial</kbd></pre>

nanoc lists all files being generated as result of this command. This is what you’ll see:

<pre><span class="prompt">%</span> <kbd>nanoc create-site tutorial</kbd>
      <span class="log-create">create</span>  nanoc.yaml
      <span class="log-create">create</span>  Rules
      <span class="log-create">create</span>  content/index.html
      <span class="log-create">create</span>  content/stylesheet.css
      <span class="log-create">create</span>  layouts/default.html
Created a blank nanoc site at 'tutorial'. Enjoy!
<span class="prompt">%</span> </pre>

A nanoc-powered site is a directory with a specific structure. The newly generated `tutorial` directory has a handful of different files and directories:

`nanoc.yaml`
: The YAML file that contains site-wide configuration details.

`Rules`
: The Ruby file that describes how pages and assets will be processed.

`content/`
: The directory in which pages and assets go.

`layouts/`
: The directory that contains layouts, which define the look-and-feel of the site.

`lib/`
: The directory that contains custom Ruby code.

We’ll revisit all of these later on in the tutorial.

Compile the site
----------------

All nanoc commands, except for `create-site`, require the current working directory to be a nanoc site. <kbd>cd</kbd> into the `tutorial` directory, if you haven’t yet done so:

<pre><span class="prompt">%</span> <kbd>cd tutorial</kbd>
<span class="prompt">tutorial%</span></pre>

Every new nanoc site comes with one simple page, `content/index.html`. The content of this page is only a HTML snippet rather than a full HTML file. To generate the full HTML file, compile the site by running <kbd>nanoc</kbd>:

<pre><span class="prompt">tutorial%</span> <kbd>nanoc</kbd></pre>

You can also type `nanoc compile`, for which `nanoc` is a shorthand.

nanoc will tell what is happening during the compilation process:

<pre><span class="prompt">tutorial%</span> <kbd>nanoc compile</kbd>
Loading site data…
Compiling site…
      <span class="log-create">create</span>  [0.01s] output/index.html

Site compiled in 0.01s.
<span class="prompt">tutorial%</span> </pre>

nanoc created a file named `index.html` in the `output` directory. If you open this file in a text editor, you will see that this is a full HTML file.

Because nanoc generates absolute paths by default, opening the file directly in a web browser will not produce the desired result: links will be broken and the browser won’t be able to find the stylesheet.

The recommended way of previewing a site is using the <kbd>nanoc view</kbd> command, which starts a local web server that mimics a real-world web server. Before you can use this command, install the `adsf` gem (_not_ `asdf`!) first:

<pre><span class="prompt">tutorial%</span> <kbd>gem install adsf</kbd></pre>

<div class="admonition note">You might have to prefix the <kbd>gem install</kbd> command with <kbd>sudo</kbd>.</div>

Now you can start a web server by running <kbd>nanoc view</kbd>:

<pre><span class="prompt">tutorial%</span> <kbd>nanoc view</kbd></pre>

Open a web browser and navigate to <span class="uri">http://localhost:3000/</span>. You’ll see something like this:

<figure class="fullwidth">
	<img src="/assets/images/tutorial/default-site.png"
	     alt="Screenshot of what a brand new nanoc site looks like">
	<figcaption>Screenshot of what a brand new nanoc site looks like</figcaption>
</figure>

Edit the home page
------------------

Pages and assets (commonly referred to as _items_) in a nanoc site are stored in the `content` directory. Open the `content/index.html` file. You will see something like this:

<pre><code>---
title: Home
---

&lt;h1>A Brand New nanoc Site&lt;/h1>

&lt;p>You’ve just created a new nanoc site. The page you are looking at right now is the home page for your site. To get started, consider replacing this default homepage with your own customized homepage. Some pointers on how to do so:&lt;/p>

…</code></pre>

Add a paragraph somewhere in the file. I recommend adding the following:

<pre><code class="language-html">
&lt;p>Another nanoc convert! Master will be pleased.&lt;/p>
</code></pre>

Recompile the site by running <kbd>nanoc</kbd>:

<pre><span class="prompt">tutorial%</span> <kbd>nanoc</kbd>
Loading site data…
Compiling site…
      <span class="log-update">update</span>  [0.01s] output/index.html

Site compiled in 0.01s.
<span class="prompt">tutorial%</span> </pre>

Make sure that the preview server (<kbd>nanoc view</kbd>) is still running, and reload <span class="uri">http://localhost:3000/</span> in your browser. You’ll see the page and the newly added paragraph.

Items, such as this home page, can contain metadata. This metadata is defined in the _frontmatter_ of a file. The home page’s frontmatter is quite simple:

<pre><code class="language-yaml">---
title: Home
---</code></pre>

<div class="admonition note">The term <i>metadata section</i> is often used instead of <i>frontmatter</i> in the context of nanoc. Other static site generators, such as Jekyll, use the term <i>frontmatter</i> almost exclusively.</div>

The frontmatter is formatted as YAML. If you are unfamiliar with YAML, check out the [YAML cookbook](http://www.yaml.org/YAML_for_ruby.html). There are no pre-defined attributes in nanoc, and you are free to invent your own attributes.

Change the value of the `title` attribute to something else:

<pre><code class="language-yaml">---
title: "Denis’ Guide to Awesomeness"
---</code></pre>

Recompile the site and reload <span class="uri">http://localhost:3000/</span> in your browser. You will see that the browser’s title bar displays the new page title now. (The mechanism behind this will be explained in the [Customize the layout](#customize-the-layout) section below.)

Add a page
----------

Create a file named <span class="filename">content/about.html</span> and paste in the following content:

    #!html
    ---
    title: "About me and my cats"
    ---

    <h1>My cute little "About" page</h1>

    <p>This is the about page for my new nanoc site.</p>

<div class="admonition note">nanoc also provides a <code>nanoc create-item</code> command that can be used to create new items. However, it doesn’t do anything more than creating a new file for you. In nanoc 4.0, the <code>create-item</code> and <code>create-layout</code> commands will be removed.</div>

Recompile the site by issuing <kbd>nanoc</kbd>. Notice that nanoc creates a file `output/about/index.html`. Open <span class="uri">http://localhost:3000/about/</span> in your browser, and admire your brand new about page. Shiny!

<div class="admonition note">If you do not like having a metadata section at the top of every page (perhaps because it breaks syntax highlighting), you can put the metadata in a YAML file with the same name as the page itself. For example, the <span class="filename">content/about.html</span> page could have its metadata stored in <span class="filename">content/about.yaml</span> instead.</div>

Customize the layout
--------------------

The look and feel of a site is defined in layouts. Open the site’s default (and only) layout, `layouts/default.html`, your text editor. It *almost* looks like a HTML page, except for the metadata section at the top of the file, and eRuby (Embedded Ruby) instructions such as the `<%= yield %>` one:

    #!html
    …
    <div id="main">
      <%= yield %>
    </div>
    …

Two main eRuby instructions exist:

`<% code %>`
:   Runs the code between `<%` and `%>`

`<%= code %>`
:   Runs the code between `<%=` and `%>`, and displays the return value on the web page

<div class="admonition note">nanoc is not limited to eRuby. It comes with support for Haml and Mustache, and adding support for other layout engines is easy using filters, which are explained in the <a href="#write-pages-in-markdown">Write pages in Markdown</a> section below.</div>

The `<%= yield %>` instruction is replaced with the item’s compiled content when compiling.

The file also contains the `<%= @item[:title] %>` instruction near the top of the file. This is replaced with the contents of the `title` attribute during compilation.

Because nanoc attributes are free-form, you can make up your own attributes. Set the `author` attribute on the about page:

    #!yaml
    ---
    title: "About me and my cats"
    author: "John Doe"
    ---

Modify the layout to show the value of the `author` attribute. Add the following snippet to the layout:

    #!html
    <% if @item[:author] %>
      <p>This page was written by <%= @item[:author] %>.</p>
    <% end %>

Recompile the site and open both the home page and the about page. The about page contains a paragraph mentioning John Doe as the author, while the home page does not.

Write pages in Markdown
-----------------------

nanoc has _filters_, which transform content from one format into another.

A language that is commonly used instead of HTML is [Markdown](http://daringfireball.net/projects/markdown). nanoc comes with several different Markdown filters, including a filter for [kramdown](http://kramdown.gettalong.org/), a fast and featureful Markdown processor.

Get rid of the content in <span class="filename">content/index.html</span> (but leave the forematter intact), and replace it with Markdown:

    ---
    title: "Denis’ Guide to Awesomeness"
    ---

    Now is the time for all good men to come to the aid of their country. This is just a regular paragraph.

    ## Shopping list

    1. Bread
    2. Butter
    3. Refined uranium

Rename the <span class="filename">content/index.html</span> file to <span class="filename">content/index.md</span>. `md` is a file extension that is commonly used with Markdown.

Before we can use the `kramdown` gem, it needs to be installed:

<pre><span class="prompt">%</span> <kbd>gem install kramdown</kbd></pre>

<div class="admonition note">You might have to prefix the <kbd>gem install</kbd> command with <kbd>sudo</kbd>.</div>

The <span class="filename">Rules</span> file is used to describe the processing rules for items and layouts. This is the file that needs to be modified in order to tell nanoc to use the kramdown filter.

The first point of interest in the <span class="filename">Rules</span> is this _compilation rule_:

    #!ruby
    compile '*' do
      if item[:extension] == 'css'
        # don’t filter stylesheets
      elsif item.binary?
        # don’t filter binary items
      else
        filter :erb
        layout 'default'
      end
    end

The second point of interest is the _routing rule_:

    #!ruby
    route '*' do
      if item[:extension] == 'css'
        # Write item with identifier /foo/ to /foo.css
        item.identifier.chop + '.css'
      elsif item.binary?
        # Write item with identifier /foo/ to /foo.ext
        item.identifier.chop + '.' + item[:extension]
      else
        # Write item with identifier /foo/ to /foo/index.html
        item.identifier + 'index.html'
      end
    end

Compilation rules describe how items are processed, while routing rule describe where items are written to. Each item matches exactly one compilation rule and one routing rule.

The string argument defines what items will be processed using this rule. The `*` wildcard matches zero or more characters, so in this case, both rules match all items.

Modify the compilation rule to add a check for the `md` file extension. In this case, run the `:kramdown` filter on items that have a `md` extension, and apply the default layout:

    #!ruby
    compile '*' do
      if item[:extension] == 'md'
        filter :kramdown
        layout 'default'
      elsif item[:extension] == 'css'
        # don’t filter stylesheets
      elsif item.binary?
        # don’t filter binary items
      else
        filter :erb
        layout 'default'
      end
    end

The routing rule still matches our needs, so keep that one intact.

Recompile the site and load the home page in your web browser. You’ll see a paragraph, a header and a list. In <span class="filename">output/index.html</span>, you will find the converted HTML:

    #!html
    <p>Now is the time for all good men to come to the aid of their country. This is just a regular paragraph.</p>

    <h2 id="shopping-list">Shopping list</h2>

    <ol>
      <li>Bread</li>
      <li>Butter</li>
      <li>Refined uranium</li>
    </ol>

Writing some Custom Code
------------------------

There is a directory named `lib` in your nanoc site. In there, you can throw Ruby source files, and they’ll be read and executed before the site is compiled. This is therefore the ideal place to define helper methods.

As an example, let’s add some tags to a few pages, and then let them be displayed in a clean way using a few lines of custom code. Start off by giving the "about" page some tags. Open `about.html` and add this to the meta section:

<pre title="Tags to be added to the about page’s metadata"><code class="language-yaml">
tags:
  - foo
  - bar
  - baz
</code></pre>

Next, create a file named `tags.rb` in the `lib` directory (the filename doesn’t really matter). In there, put the following function:

<pre title="Code snippet to be put in the lib directory"><code class="language-ruby">
def tags
  if @item[:tags].nil?
    '(none)'
  else
    @item[:tags].join(', ')
  end
end
</code></pre>

This function will take the current page’s tags and return a comma-separated list of tags. If there are no tags, it returns "(none)". To put this piece of code to use, open the default layout and add this line right above the <code>&lt;%= yield %></code> line:

<pre title="Code snippet to be added to the default layout"><code class="language-html">
&lt;p>Tags: &lt;%= tags %>&lt;/p>
</code></pre>

Recompile the site, and take a look at both HTML files in the `output` directory. If all went well, you should see a list of tags right above the page content.

Writing your own functions for handling tags is not really necessary, though, as nanoc comes with a tagging helper by default. To enable this tagging helper, first delete `tags.rb` and create a `helper.rb` file (again, the filename doesn’t really matter) and put this inside:

<pre title="Code snippet to be added to the lib directory"><code class="language-ruby">
include Nanoc::Helpers::Tagging
</code></pre>

This will make all functions defined in the `Nanoc::Helpers::Tagging` module available for use. You can check out the [API documentation for the Tagging helper](/docs/api/Nanoc/Helpers/Tagging.html), but there is only one function we’ll use: `tags_for`. It’s very similar to the `tags` function we wrote before. Update the layout with this:

<pre title="Code snippet to be added to the default layout"><code class="language-html">
&lt;p>Tags: &lt;%= tags_for(@item) %>&lt;/p>
</code></pre>

Now compile the site again, and you’ll see that nanoc shows the tags for the page, but this time using the built-in tagging helper.

nanoc comes with quite a few useful helpers. The [API documentation](/docs/api/) describes each one of them.

That’s it!
----------

This is the end of the tutorial. I hope that this tutorial both whet your appetite, and gave you enough information to get started with nanoc.

There’s more reading material. It’s definitely worth checking out the following chapters; they’re rather big, but they contains everything you need to know about nanoc.
