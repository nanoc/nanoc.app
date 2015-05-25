---
title: "About nanoc"
short_title: "About"
up_to_date_with_nanoc_4: true
---

nanoc is a flexible <span class="firstterm">static site generator</span>.

A static site generator, often abbreviated as <span class="firstterm">SSG</span>, is a tool that transforms content from one format, such as Markdown or AsciiDoc, into another format, usually HTML, and lays out pages so that the site’s look and feel is consistent across all pages. Static sites can be deployed to any web server.

nanoc is not:

a <abbr title="content management system">CMS</abbr>
: It does not help in managing content; it merely processes it. Management of content is usually done on the filesystem.

a web application
: nanoc is a command-line application. With nanoc, developing sites happens on a local machine, and the generated site is deployed when it is finished.

Because nanoc is a programmable tool, a basic understanding of Ruby is quite helpful.

Advantages of static site generators
------------------------------------

Static site generators have several advantages over classical content management systems:

fast
: Static files can be served fast. There is no database or templating layer that slows requests down. Additionally, web servers will automatically set caching headers (such as `Last-Modified`) for static files, which reduce bandwidth usage.

secure
: Static sites do not contain dynamic content, and are therefore immune to most common attacks.

previewable
: Because static sites are developed locally, you can play around with the site to your heart’s content without affecting the live site.

versionable
: Static site generators commonly store their content in flat text files. This makes them ideal to be used with version control system, such as [Git](http://git-scm.com/). Because of this, many sites built with static site generators are open-source.

NOTE: Just because static sites are safer than dynamic sites does not mean you don’t need to take security into account. Use strong passwords, don’t communicate credentials over plaintext, etc.

Why use nanoc?
--------------

nanoc is suitable for a wide variety of sites, including personal blogs, portfolios and product web sites. Some unique features of nanoc include:

* support for free-form metadata
* support for various markup languages (Markdown, AsciiDoc, Textile, …)
* support for various templating languages (eRuby, Haml, Mustache, …)
* ability to write custom filters and helpers
* ability to pull in data from other sources (databases, web APIs, …)
* integration with various deployment mechanisms
* ability to run pre-deployment checks

Some of the sites built with nanoc include the <a href="https://developer.github.com/">GitHub Developer site</a>, the <a href="http://www.dadt.com/uglybetty/">Ugly Betty site</a> and the <a href="http://guides.spreecommerce.com/api/">Spree Commerce API site</a>.

Programmability combined with free-form metadata is what makes nanoc flexible. It is agnostic to what content you provide; with metadata you can turn pages into articles, chapters, review, recipes and more, and have them processed in specialised ways. Nothing in nanoc is predefined, so it gives the power to build sites that meet their goals perfectly.

Similar projects
----------------

There are several static site generators floating around. Some of them are like nanoc, and some of them aren’t similar at all. If nanoc doesn’t fulfill your needs, check out [this list of static site generators](http://staticsitegenerators.net/).
