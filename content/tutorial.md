(If you already have a bit of experience with nanoc, you may find the [Manual](/manual/) a very useful resource in addition to this tutorial.)

Installing nanoc
-----

nanoc requires [Ruby](http://www.ruby-lang.org/) (1.8.6 or higher required). nanoc also requires [RubyGems](http://rubyforge.org/projects/rubygems/). You may already have RubyGems installed, but if you don't, [get it here](http://rubyforge.org/frs/?group_id=126).

Once you have RubyGems, installing nanoc is easy. Simply write this in your terminal:

	sudo gem install nanoc3

Requirements for this Tutorial
-----

This tutorial requires [BlueCloth](http://www.deveiate.org/projects/BlueCloth). BlueCloth is a Ruby implementation of [Markdown](http://daringfireball.net/projects/markdown/), which allows you to write HTML in a easy-to-use plain text format (if you haven't used Markdown before, don't fear--it's easy). To install BlueCloth, jump to your terminal and type:

	sudo gem install BlueCloth

Creating your First nanoc-powered Site
-----

nanoc is a command-line application. This means that in order to use nanoc, you have to type geeky commands into a terminal all day. Hey, that's the way all cool apps work (or maybe not).

A nanoc-powered site is a directory with a specific structure. In this tutorial, we'll create a site named `tutorial`. To create this site, type into the terminal:

	nanoc3 create_site tutorial

If you did that right, you should have seen this appear on the screen:

	create  config.yaml
	create  Rakefile
	create  Rules
	create  content/index.yaml
	create  content/index.html
	create  layouts/default.yaml
	create  layouts/default.html
	create  lib/default.rb

The nanoc-powered site named `tutorial` has now been created. Go into the directory and list the files there. You should see something like this:

	-rw-r--r--  1 ddfreyne  staff   22 Jul 30 10:08 Rakefile
	-rw-r--r--  1 ddfreyne  staff  142 Jul 30 10:08 Rules
	-rw-r--r--  1 ddfreyne  staff  100 Jul 30 10:08 config.yaml
	drwxr-xr-x  4 ddfreyne  staff  136 Jul 30 10:08 content
	drwxr-xr-x  4 ddfreyne  staff  136 Jul 30 10:08 layouts
	drwxr-xr-x  3 ddfreyne  staff  102 Jul 30 10:08 lib
	drwxr-xr-x  3 ddfreyne  staff  102 Jul 30 10:08 output

What all those files and directories are for will be explained in just a minute, step by step.

Compiling the Site
-----

Before doing anything else, make sure the current working directory is the site you just created. All nanoc commands, except for `create_site`, require the current working directory to be a nanoc site. So, if you haven't done it before:

	cd tutorial

Every new nanoc site already has a bit of content. It comes with one simple page with some simple "getting started" instructions. Before you can view the site, it needs to be compiled. To compile the site, do this:

	nanoc3 compile

This is what'll appear in the terminal when nanoc is done compiling:

	Loading site data...
	Compiling site...
    create  [0.01s] output/index.html

	Site compiled in 0.01s.

A file named `index.html` has been created in the `output` directory. Open it in your favourite web browser (mine is Safari); what you'll see is something like this:

<div class="figure">
	<img style="border: 6px solid #ccc" src="/assets/images/tutorial/default-site.png"
	     alt="Screenshot of what a brand new nanoc site looks like">
</div>

You can also open the `output/index.html` file in your favourite text editor, where you'll find that the file is just a normal HTML page. No big surprise there.

Editing the Home Page
-----

The first step in getting to know how nanoc really works will involve editing the content of the home page. First, though, a quick explanation of how uncompiled pages are stored.

The pages in a nanoc site are stored in the `content` directory. Currently, that directory has only two files: `index.html` and `index.yaml`. These two files together form the home page. The file ending with `.yaml` contain the page's attributes (or metadata, or properties, or whatever you want to call it), while the other file contains the actual page content. This may sound confusing, but it'll make more sense once more pages are added to the site. Patience, young padawan.

Let's change the content of the home page. Open `index.html` and add a paragraph somewhere in the file. I recommend something like this:

<% syntax_colorize 'html' do %>
	<p>This is a brand new paragraph which I've just inserted into this file! Gosh, I can barely control my excitement!</p>
<% end %>

To view the changes, the site must be recompiled first. So, do this:

	nanoc3 compile

And this is what you'll see:

	Loading data...
	Compiling site...
	update  [0.01s] output/index.html
	
	Site compiled in 0.01s.

The number between brackes next to the `output/index.html`filename indicates the time it took for nanoc to compile the home page. At the bottom, the total time needed for compiling the entire site is also shown.

Open `index.html` in the `output` directory in your web browser and your text editor again, and verify that the page has indeed been updated.

One thing that hasn't changed is the page title--the title that appears in the browser's title bar. The page title is defined in the page's meta file. Such a meta file contains all metadata about the page, e.g. the layout that should be used for this page, the page title, the page's author, when this page was created, &hellip; The homepage meta file, `index.yaml`, looks like this right now:

<% syntax_colorize 'yaml' do %>
	title: "Home"
<% end %>

This file is formatted as YAML and contains attributes for the page it belongs to. All attributes are free-form; you can put anything you want in the attributes: the page title, keywords relevant to this page, the name of the page's author, the language the page is written in, etc.

The homepage's meta file currently has one attribute, `title`. Change this to something cooler, like this:

<% syntax_colorize 'yaml' do %>
	title: "The Guild of nanoc: a fan website dedicated to nanoc"
<% end %>

Recompile the site and open `index.html` in your browser. You will see that the browser's title bar displays the page's title now. If you're wondering how exactly nanoc knew that it had to update the stuff between the `<title>` and `</title>` tags: don't worry. There's no magic involved. It'll all become crystal clear in a minute. (Take a peek at `layouts/default.html` if you're curious.)

Adding a Page
-----

In nanoc, pages are sometimes referred to as "items." This is because items don't necessarily have to be pages: JavaScript and CSS files aren't pages, but they are items.

To create a new page or item in the site, use the `create_item` command (or `ci` for short). Let's create an "about" page like this:

	nanoc3 create_item about

You should see this:

	create  content/about.yaml
	create  content/about.html

There are now two new files that form the about page: the content file (`content/about.html`) and the meta file (`content/about.yaml`). Open the content file and put some text in it, like this:

<% syntax_colorize 'html' do %>
	<h1>My cute little "About" page</h1>
	
	<p>This is the about page for my new nanoc site.</p>
<% end %>

Edit the meta file (the YAML one) so it looks like this:

<% syntax_colorize 'yaml' do %>
	title: "The Guild of nanoc -- About the Guild"
<% end %>

Recompile the site, and notice that a file `output/about/index.html` has been created. Open that file in your web browser, and admire your brand new about page. Shiny!

Customizing the Layout
-----

The default home page recommended editing the default layout, so let's see what we can do there.

As you probably have noticed already, the page's content files are not complete HTML files--they are *partial* HTML files. A page needs `<html>`, `<head>`, `<body>`, … elements before it's valid HTML. This doesn't mean you've been writing invalid HTML all along, though, because nanoc *layouts* each page as a part of the compilation process.

Take a look in the `layouts` directory. It contains two files: `default.html` and `default.yaml`. These two files form the default layout of the web site, and is also the layout used by the home page and the about page.

Open `default.html` in your favourite text editor. It *almost* looks like a HTML page, with the exception of this piece of code:

<% syntax_colorize 'html' do %>
	...
	<div id="main">
	  <%%= yield %>
	</div>
	...
<% end %>

The odd construct in the middle of that piece of code is an *embedded Ruby* instruction. The `<%%= yield %>` instruction will be replaced with the item's compiled content when compiling.

If you are not familiar with embedded Ruby (also known as eRuby), take a look at the [eRuby article on Wikipedia](http://en.wikipedia.org/wiki/ERuby), or the [<i>Embedding Ruby in HTML</i> section](http://ruby-doc.org/docs/ProgrammingRuby/html/web.html#S2) of the <i>Ruby and the Web</i> chapter of the online <i>Programming Ruby</i> book.

In fact--maybe you've noticed it already--there's another important piece of embedded Ruby code near the top of the file:

<% syntax_colorize 'html_rails' do %>
	<title>A Brand New nanoc Site - <%%= @item[:title] %></title>
<% end %>

This is where the page's title is put into the compiled document.

Every page can have arbitrary metadata associated with it. For example, you can set the `author_name` attribute to your own name, quite similar to how the `title` attribute is set. To demonstrate this, add the following line to the meta file:

<% syntax_colorize 'yaml' do %>
	author: "John Doe"
<% end %>

Now output the author name in the layout. Put this piece of code somewhere in your layout (somewhere between the `<body>` and `</body>` tags, please, or you won't see a thing):

<% syntax_colorize 'html_rails' do %>
	<%% if @item[:author] %>
	  <p>This page was written by <%%= @item[:author] %>.</p>
	<%% end %>
<% end %>

Recompile the site, and open the `output/index.html` and `output/about/index.html` pages in your browser. You'll see that the about page has a line saying <q>This page was written by John Doe</q>, while the home page does not--as expected!

Writing Pages in Markdown
-----

You don't have to write pages in HTML. Sometimes, it is easier to use another language which can be converted to HTML instead. In this example, we'll use [Markdown](http://daringfireball.net/projects/markdown) to avoid having to write HTML. nanoc calls these text transformations *filters*.

Let's get rid of the contents of the home page and replace it with some Markdown-formatted text. Open `content/index.html` and put this in instead:

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
	> ## This is an H2 in a blockquote`</pre>

To tell nanoc to run the home page through the `bluecloth` filter, the `Rules` file is used. This file specifies all processing instructions for all items. It consists of a series of rules, which in turn consist of three parts:

the *rule type*
: This can be `compile` (which specifies the filters and layouts to apply), `route` (which specifies where a compiled page should be written to) or `layout` (which specifies the filter to use for a given layout).

the *selector*
: This determines what items or layouts the rule applies to. It can contain the `*` wildcard, which matches anything. The default rules file has three rules of each type, and they all apply to all items or layouts.

the *processing instructions*
: This is the code inside the `do…end` block and specifies what exactly should be done with the items that match this rule.

These rules are quite powerful and are not fully explained in this tutorial. I recommend checking out the manual for a more in-depth explanation of the rules file.

Take a look at the default compilation rule (the `compile '*' do … end` one). This rule applies to all items due to the `*` wildcard. When this rule is applied to an item, the item will first be filtered through the `erb` filter and will then be laid out using the `default` layout.

To make sure that the home page (but not any other page) is run through the `bluecloth` filter, add this piece of code *before* the existing compilation rule:.

<% syntax_colorize 'ruby' do %>
	compile '/' do
	  filter :bluecloth
	  layout 'default'
	end
<% end %>

It is important that this rule comes *before* the existing one (`compile '*' do … end`). When compiling a page, nanoc will use the first and only the first matching rule; if the new compilation rule were *below* the existing one, it would never have been used.

Now that we've told nanoc to filter this page using BlueCloth, let's recompile the site. (If you are getting errors at this point, make sure you have BlueCloth installed, as described at the beginning of this tutorial). The `output/index.html` page source should now contain this text (header and footer omited):

<% syntax_colorize 'html' do %>
	<h1>A First Level Header</h1>

	<h2>A Second Level Header</h2>

	<p>Now is the time for all good men to come to
	the aid of their country. This is just a
	regular paragraph.</p>

	<p>The quick brown fox jumped over the lazy
	dog's back.</p>

	<h3>Header 3</h3>

	<blockquote>
	    <p>This is a blockquote.</p>

	    <p>This is the second paragraph in the blockquote.</p>

	    <h2>This is an H2 in a blockquote</h2>
	</blockquote>
<% end %>

The BlueCloth filter is not the only filter you can use--take a look a the [full list of filters included with nanoc](#). You can also write your own filters--read the [Writing Filters](/manual/#writing-filters) section in the manual for details.

Writing some Custom Code
-----

There is a directory named `lib` in your nanoc site. In there, you can throw Ruby source files, and they'll be read and executed before the site is compiled. This is therefore the ideal place to define helper methods. 

As an example, let's add some tags to a few pages, and then let them be displayed in a clean way using a few lines of custom code. Start off by giving the "about" page some tags. Open `about.yaml` and add this to the end of the "custom" section:

<% syntax_colorize 'yaml' do %>
tags:
  - foo
  - bar
  - baz
<% end %>

Next, create a file named `tags.rb` in the `lib` directory (the filename doesn't really matter). In there, put the following function:

<% syntax_colorize 'ruby' do %>
	def tags
	  if @item[:tags].nil?
	    '(none)'
	  else
	    @item[:tags].join(', ')
	  end
	end
<% end %>

This function will take the current page's tags and return a comma-separated list of tags. If there are no tags, it returns "(none)". To put this piece of code to use, open the default layout and add this line right above the `<%%= yield %>` line:

<% syntax_colorize 'html_rails' do %>
	<p>Tags: <%%= tags %></p>
<% end %>

Recompile the site, and take a look at both HTML files in the `output` directory. If all went well, you should see a list of tags right above the page content.

Writing your own functions for handling tags is not really necessary, though, as nanoc comes with a tagging helper by default. To enable this tagging helper, first delete `tags.rb` and create a `helper.rb` file (again, the filename doesn't really matter) and put this inside:

<% syntax_colorize 'ruby' do %>
	include Nanoc3::Helpers::Tagging
<% end %>

This will make all functions defined in the `Nanoc3::Helpers::Tagging` module available for use. You can check out the [RDoc documentation for the Tagging helper](/doc/3.0.0/Nanoc3/Helpers/Tagging.html), but there is only one function we'll use: `tags_for`. It's very similar to the `tags` function we wrote before. Update the layout with this:

<% syntax_colorize 'html_rails' do %>
	<p>Tags: <%%= tags_for(@item) %></p>
<% end %>

nanoc comes with quite a few useful helpers. The [RDoc documentation](/doc/3.0.0/) describes each one of them.

Watch out for Paths
-----

There's one tricky thing involving paths that you need to know. To show you what can go wrong, let's create a stylesheet named `style.css` in the output directory. Here's what I put in there:

<% syntax_colorize 'css' do %>
	h1, h2, h3 { color: red; }
<% end %>

To link the stylesheet to the web site, open the layout (`default.html`) and put this in:

<% syntax_colorize 'html' do %>
	<link href="style.css" rel="stylesheet" type="text/css">
<% end %>

When you compile the site now and open `index.html`, you'll see that all headers are red. `about/index.html`'s headers, however, are not styled—the web browser looks for a `about/style.css` which doesn't exist.

The most elegant solution is to use an absolute path, like this (note the new slash):

<% syntax_colorize 'html' do %>
	<link href="/style.css" rel="stylesheet" type="text/css">
<% end %>

The compiled files in the output directory will *definitely* not be styled now if you open them by double-clicking, but that's okay—when the site is put on your web server, web browsers *will* find the stylesheet.

This would mean that you can't preview your site locally anymore, but there's a neat solution for that too. nanoc comes with an auto-compiler, which is a web server that compiles pages on-the-fly. More importantly, the output directory is its web root, so absolute paths are no issue anymore. To start it:

	nanoc3 aco

This starts a server on localhost, port 3000 (you can customize the port with `-p` if you want). Now you can go to http://localhost:3000/ and absolute paths will pose no problem anymore.

That's it!
-----

This is the end of the tutorial. I hope that this tutorial both whet your appetite, and gave you enough information to get started with nanoc.

There's more reading material. It's definitely worth checking out the [Manual](/manual/)--it's rather big, but it contains everything you need to know about nanoc.
