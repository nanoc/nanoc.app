---

title:                 "Getting Started"
markdown:              advanced
toc_includes_sections: true

---

Requirements
------------

This tutorial does not cover the installation of nanoc. For information on how to install nanoc, as well as Ruby and Rubygems, check out the [Installation](/docs/2-installation/) page.

This tutorial requires [kramdown](http://kramdown.rubyforge.org/). Kramdown is a Ruby implementation of [Markdown](http://daringfireball.net/projects/markdown/), which allows you to write HTML in a easy-to-use plain text format. If you haven’t used Markdown before, don’t fear—it’s quite easy to use. To install kramdown, jump to your terminal and type:

<pre title="Installing kramdown"><span class="prompt">%</span> <kbd>gem install kramdown</kbd></pre>

You should also install [adsf](http://stoneship.org/software/adsf/), a tool that allows you to fire up a web server in any directory, which is very useful for previewing compiled nanoc sites. nanoc’s <kbd>view</kbd> command, used in this tutorial, requires adsf to be installed. Install adsf like this:

<pre title="Installing adsf"><span class="prompt">%</span> <kbd>gem install adsf</kbd></pre>

Be sure to install _adsf_, not _asdf_. No, that’s not a tyop!

nanoc also requires a basic level of experience with Ruby. It is possible to use nanoc with no Ruby knowledge, but to take full advantage of nanoc, you’ll need to know Ruby well. I recommend the [Programming Ruby](http://ruby-doc.org/docs/ProgrammingRuby/) book to people who don’t have a lot of Ruby experience yet.

Creating a Site
---------------

nanoc is a command-line application. This means that in order to use nanoc, you have to type geeky commands into a terminal all day. Hey, that’s the way all cool apps work.

A nanoc-powered site is a directory with a specific structure. In this tutorial, we’ll create a site named `tutorial`. To create this site, type into the terminal:

<pre title="Creating a new site"><span class="prompt">%</span> <kbd>nanoc create_site tutorial</kbd></pre>

If you did that right, you should see something like this in the terminal:

<pre title="Creating a new site (with command output)"><span class="prompt">%</span> <kbd>nanoc create_site tutorial</kbd>
      <span class="log-create">create</span>  config.yaml
      <span class="log-create">create</span>  Rakefile
      <span class="log-create">create</span>  Rules
      <span class="log-create">create</span>  content/index.html
      <span class="log-create">create</span>  content/stylesheet.css
      <span class="log-create">create</span>  layouts/default.html
Created a blank nanoc site at 'tutorial'. Enjoy!
<span class="prompt">%</span> </pre>

The nanoc-powered site named `tutorial` has now been created. Go into the directory and list the files there. You should see something like this:

<pre title="Getting the contents of the new site directory"><span class="prompt">%</span> <kbd>cd tutorial</kbd>
<span class="prompt">tutorial%</span> <kbd>ls -l</kbd>
total 24
-rw-r--r--  1 ddfreyne  staff   22 Feb 17 14:44 Rakefile
-rw-r--r--  1 ddfreyne  staff  692 Feb 17 14:44 Rules
-rw-r--r--  1 ddfreyne  staff  100 Feb 17 14:44 config.yaml
drwxr-xr-x  4 ddfreyne  staff  136 Feb 17 14:44 content
drwxr-xr-x  3 ddfreyne  staff  102 Feb 17 14:44 layouts
drwxr-xr-x  3 ddfreyne  staff  102 Feb 17 14:44 lib
drwxr-xr-x  2 ddfreyne  staff   68 Feb 17 14:44 output
<span class="prompt">tutorial%</span> </pre>

What all those files and directories are for will all become clear soon.

Compiling the Site
------------------

Before doing anything else, make sure the current working directory is the site you just created. All nanoc commands, except for <kbd>create_site</kbd>, require the current working directory to be a nanoc site. So, if you haven’t done it before:

<pre title="Going into the site directory"><span class="prompt">%</span> <kbd>cd tutorial</kbd>
<span class="prompt">tutorial%</span></pre>

Every new nanoc site already has a bit of content. It comes with one simple page with some simple "getting started" instructions. Before you can view the site, it needs to be compiled. To compile the site, do this:

<pre title="Compiling the new site"><span class="prompt">tutorial%</span> <kbd>nanoc compile</kbd></pre>

Or, if you want it short, just type <kbd>nanoc</kbd>:

<pre title="Compiling the new site"><span class="prompt">tutorial%</span> <kbd>nanoc</kbd></pre>

This is what’ll appear in the terminal while nanoc is compiling:

<pre title="Compiling the new site (with command output)"><span class="prompt">tutorial%</span> <kbd>nanoc compile</kbd>
Loading site data…
Compiling site…
      <span class="log-create">create</span>  [0.01s] output/index.html

Site compiled in 0.01s.
<span class="prompt">tutorial%</span> </pre>

A file named `index.html` has been created in the `output` directory. Start a web server using the <kbd>view</kbd> command, like this:

<pre title="Compiling a site"><span class="prompt">tutorial%</span> <kbd>nanoc view</kbd></pre>

Now, open your web browser and navigate to [http://localhost:3000/](http://localhost:3000/). What you’ll see is something like this:

<div class="figure">
	<img src="/assets/images/tutorial/default-site.png"
	     alt="Screenshot of what a brand new nanoc site looks like">
</div>

(If you open the `index.html` directly in your web browser, the stylesheet will most likely not be loaded. This is because the page has an _absolute_ link to the `style.css` file, not a relative one.)

You can also open the `output/index.html` file in your favourite text editor, where you’ll find that the file is just a normal HTML page.

Editing the Home Page
---------------------

The first step in getting to know how nanoc really works will involve editing the content of the home page. First, though, a quick explanation of how uncompiled pages are stored.

The pages in a nanoc site are stored in the `content` directory. Currently, that directory has only two files: `index.html` and `stylesheet.css`. The first file forms the home page, while the second file is the stylesheet. If you open the `index.html` file, you’ll notice a section containing metadata in YAML format at the top.

Let’s change the content of the home page. Open `index.html` and add a paragraph somewhere in the file. I recommend something like this:

<pre title="Sample content to be added to index.html"><code class="language-html">
&lt;p>This is a brand new paragraph which I've just inserted into this file! Gosh, I can barely control my excitement!&lt;/p>
</code></pre>

To view the changes, the site must be recompiled first. So, run the <kbd>compile</kbd> command. You should see something like this:

<pre title="Compiling the site again"><span class="prompt">tutorial%</span> <kbd>nanoc compile</kbd>
Loading site data…
Compiling site…
      <span class="log-update">update</span>  [0.01s] output/index.html

Site compiled in 0.01s.
<span class="prompt">tutorial%</span> </pre>

The number between brackets next to the `output/index.html` filename indicates the time it took for nanoc to compile the home page. At the bottom, the total time needed for compiling the entire site is also shown.

Make sure that the preview server (<kbd>nanoc view</kbd>) is still running, reload [http://localhost:3000/](http://localhost:3000/) in your browser, and verify that the page has indeed been updated.

In the same file, let’s change the page title from "Home" to something more interesting. Change the line that reads `title: "Home"` to something else. The file should now start with this:

<pre title="New first few lines of index.html"><code class="language-yaml">--- 
title: "My New Home Page"
---</code></pre>

The metadata section at the top of the file is formatted as YAML. All attributes are free-form; you can put anything you want in the attributes: the page title, keywords relevant to this page, the name of the page’s author, the language the page is written in, etc.

Recompile the site and once again load [http://localhost:3000/](http://localhost:3000/) in your browser. You will see that the browser’s title bar displays the page’s title now. If you’re wondering how exactly nanoc knew that it had to update the stuff between the `<title>` and `</title>` tags: don’t worry. There’s no magic involved. It’ll all become crystal clear in a minute. (Take a peek at `layouts/default.html` if you’re curious.)

Adding a Page
-------------

In nanoc, pages are sometimes referred to as "items." This is because items don’t necessarily have to be pages: JavaScript and CSS files aren’t pages, but they are items.

To create a new page or item in the site, use the `create_item` command (or `ci` for short). Let’s create an "about" page like this:

<pre title="Creating a new item"><span class="prompt">tutorial%</span> <kbd>nanoc create_item about</kbd></pre>

You should see this:

<pre title="Creating a new item (with output)"><span class="prompt">tutorial%</span> <kbd>nanoc create_item about</kbd>
      <span class="log-create">create</span>  content/about.html
<span class="prompt">tutorial%</span> </pre>

Open the newly generated file and put some text in it, like this (be sure to leave the metadata section intact):

<pre title="Sample content to be added to about.html"><code class="language-html">
&lt;h1>My cute little "About" page&lt;/h1>

&lt;p>This is the about page for my new nanoc site.&lt;/p>
</code></pre>

In the metadata section, change the title to something else:

<pre title="Sample metadata to be added to about.html"><code class="language-yaml">
title: "My Cool About Page"
</code></pre>

Recompile the site, and notice that a file `output/about/index.html` has been created. With the preview server running, open [http://localhost:3000/about/](http://localhost:3000/about/) in your browser and admire your brand new about page. Shiny!

By the way, if you don’t like having a metadata section at the top of every page (perhaps because it breaks syntax highlighting), you can put the metadata in a YAML file with the same name as the page itself. For example, the `content/about.html` page could have its metadata stored in `content/about.yaml` instead.

Customizing the Layout
----------------------

The default home page recommended editing the default layout, so let’s see what we can do there.

As you probably have noticed already, the page’s content files are not complete HTML files—they are *partial* HTML files. A page needs `<html>`, `<head>`, `<body>`, … elements before it’s valid HTML. This doesn’t mean you’ve been writing invalid HTML all along, though, because nanoc *layouts* each page as a part of the compilation process.

Take a look at the `default.html` file in the `layouts` directory. Just like items, it contains a metadata section at the top of the file. Open it in your text editor. It *almost* looks like a HTML page, with the exception of this piece of code:

<pre title="Extract from the default layout showing the body"><code class="language-html">…
&lt;div id="main">
  &lt;%= yield %>
&lt;/div>
…
</code></pre>

The odd construct in the middle of that piece of code is an *embedded Ruby* instruction. The `<%= yield %>` instruction will be replaced with the item’s compiled content when compiling.

If you are not familiar with embedded Ruby (also known as eRuby), take a look at the [eRuby article on Wikipedia](http://en.wikipedia.org/wiki/ERuby), or the [<i>Embedding Ruby in HTML</i> section](http://ruby-doc.org/docs/ProgrammingRuby/html/web.html#S2) of the <i>Ruby and the Web</i> chapter of the online <i>Programming Ruby</i> book.

The is another important piece of embedded Ruby code near the top of the file:

<pre title="Extract from the default layout showing the title"><code class="language-html">
&lt;title>A Brand New nanoc Site - &lt;%= @item[:title] %>&lt;/title>
</code></pre>

This is where the page’s title is put into the compiled document.

Every page can have arbitrary metadata associated with it. To demonstrate this, add the following line to the metadata section of the about page:

<pre title="New metadata to be added to the about page"><code class="language-yaml">
author: "John Doe"
</code></pre>

Now output the author name in the layout. Put this piece of code somewhere in your layout (somewhere between the `<body>` and `</body>` tags, please, or you won’t see a thing):

<pre title="Sample code to be added to the default layout"><code class="language-html">
&lt;% if @item[:author] %>
  &lt;p>This page was written by &lt;%= @item[:author] %>.&lt;/p>
&lt;% end %>
</code></pre>

Recompile the site, and load [http://localhost:3000/about/](http://localhost:3000/about/) in your browser. You’ll see that the about page has a line saying <q>This page was written by John Doe</q>, while the home page does not—as expected!

Writing Pages in Markdown
-------------------------

You don’t have to write pages in HTML. Sometimes, it is easier to use another language which can be converted to HTML instead. In this example, we’ll use [Markdown](http://daringfireball.net/projects/markdown) to avoid having to write HTML. nanoc calls these text transformations *filters*.

Get rid of the content of the home page (`content/index.html`) and replace it with the following Markdown-formatted text (but leave the metadata section intact):

<pre title="Sample content that will replace the content of the home page"><code class="language-markdown">
A First Level Header
====================

A Second Level Header
---------------------

Now is the time for all good men to come to
the aid of their country. This is just a
regular paragraph.

The quick brown fox jumped over the lazy
dog's back.

### Header 3

> This is a blockquote.
> 
> This is the second paragraph in the blockquote.
>
> ## This is an H2 in a blockquote</code></pre>

To tell nanoc to format the home page as Markdown, let nanoc run it through the `kramdown` filter. For this, the `Rules` file is used. This file specifies all processing instructions for all items. It consists of a series of rules, which in turn consist of three parts:

*rule type*
: This can be `compile` (which specifies the filters and layouts to apply), `route` (which specifies where a compiled page should be written to) or `layout` (which specifies the filter to use for a given layout).

*selector*
: This determines what items or layouts the rule applies to. It can contain the `*` wildcard, which matches anything. The default rules file has three rules of each type, and they all apply to all items or layouts.

*instructions*
: This is the code inside the `do…end` block and specifies what exactly should be done with the items that match this rule.

These rules are quite powerful and are not fully explained in this tutorial. I recommend checking out the manual for a more in-depth explanation of the rules file.

Take a look at the default compilation rule (the `compile '*' do … end` one). This rule applies to all items due to the `*` wildcard. When this rule is applied to an item, the item will first be filtered through the `erb` filter and will then be laid out using the `default` layout.

To make sure that the home page (but not any other page) is run through the `kramdown` filter, add this piece of code *before* the existing compilation rule:.

<pre title="The new compilation rule"><code class="language-ruby">
compile '/' do
  filter :kramdown
  layout 'default'
end</code></pre>

It is important that this rule comes *before* the existing one (`compile '*' do … end`). When compiling a page, nanoc will use the first and only the first matching rule; if the new compilation rule were *below* the existing one, it would never have been used.

Now that we’ve told nanoc to filter this page using kramdown, let’s recompile the site. The `output/index.html` page source should now contain this text (header and footer omited):

<pre title="The compiled home page, filtered as Markdown"><code class="language-html">
&lt;h1>A First Level Header&lt;/h1>

&lt;h2>A Second Level Header&lt;/h2>

&lt;p>Now is the time for all good men to come to
the aid of their country. This is just a
regular paragraph.&lt;/p>

&lt;p>The quick brown fox jumped over the lazy
dog's back.&lt;/p>

&lt;h3>Header 3&lt;/h3>

&lt;blockquote>
    &lt;p>This is a blockquote.&lt;/p>

    &lt;p>This is the second paragraph in the blockquote.&lt;/p>

    &lt;h2>This is an H2 in a blockquote&lt;/h2>
&lt;/blockquote>
</code></pre>

The kramdown filter is not the only filter you can use—take a look a the [full list of filters included with nanoc](/docs/4-basic-concepts/#list-of-built-in-filters). You can also write your own filters—read the [Writing Filters](/docs/5-advanced-concepts/#writing-filters) section in the manual for details.

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

This function will take the current page’s tags and return a comma-separated list of tags. If there are no tags, it returns "(none)". To put this piece of code to use, open the default layout and add this line right above the `<%= yield %>` line:

<pre title="Code snippet to be added to the default layout"><code class="language-html">
&lt;p>Tags: &lt;%= tags %>&lt;/p>
</code></pre>

Recompile the site, and take a look at both HTML files in the `output` directory. If all went well, you should see a list of tags right above the page content.

Writing your own functions for handling tags is not really necessary, though, as nanoc comes with a tagging helper by default. To enable this tagging helper, first delete `tags.rb` and create a `helper.rb` file (again, the filename doesn’t really matter) and put this inside:

<pre title="Code snippet to be added to the lib directory"><code class="language-ruby">
include Nanoc::Helpers::Tagging
</code></pre>

This will make all functions defined in the `Nanoc::Helpers::Tagging` module available for use. You can check out the [API documentation for the Tagging helper](/docs/api/3.3/Nanoc/Helpers/Tagging.html), but there is only one function we’ll use: `tags_for`. It’s very similar to the `tags` function we wrote before. Update the layout with this:

<pre title="Code snippet to be added to the default layout"><code class="language-html">
&lt;p>Tags: &lt;%= tags_for(@item) %>&lt;/p>
</code></pre>

Now compile the site again, and you’ll see that nanoc shows the tags for the page, but this time using the built-in tagging helper.

nanoc comes with quite a few useful helpers. The [API documentation](/docs/api/3.4/) describes each one of them.

That’s it!
----------

This is the end of the tutorial. I hope that this tutorial both whet your appetite, and gave you enough information to get started with nanoc.

There’s more reading material. It’s definitely worth checking out the following chapters; they’re rather big, but they contains everything you need to know about nanoc.
