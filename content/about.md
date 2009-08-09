nanoc is a tool for building static (or semi-static) web sites. It processes (or "compiles") pages and assets. It transforms ("filters") content from one format into another (from Haml into HTML for example).

nanoc is not a content management system (CMS), as it does not manage content--*you* manage the content, and nanoc processes it for you.

Unlike many CMSes and blog engines, nanoc runs on your local computer, and not on the server. It doesn't need to--nanoc produces static HTML files that can be uploaded to any web server. This also means that the server doesn't need to have anything "special" installed at all--it just needs to be able to serve static files, which every web server can.

Install
-------

Install nanoc using RubyGems (Ruby 1.8.5 or higher required):

	sudo gem install nanoc3

The latest release is <%= latest_release_version %>. Release notes for this version (or check out the [older release notes](/about/release-notes/)):

<%= latest_release_notes %>

nanoc's Birth
-------------

Before nanoc, I was in an eternal search for a CMS that would work well for [Stoneship](http://stoneship.org/), my personal website. I've tried bBlog, WordPress, TextPattern, Mephisto, and more. I didn't really like any of them: they were either hard to use or very resource-hungry.

At some point, [Wim Vander Schelden](http://fixnum.org/), a friend of mine, wrote a set of Ruby scripts for managing his site offline. With those scripts, you could compile a site and upload the resulting static HTML pages to a web server. I loved the idea, stole it, and turned it into what later became nanoc.

The name "nanoc" used to mean "nano-CMS". nanoc is, however, not a CMS, and it's not exactly nano-tiny either. Also, just in case you were wondering, nanoc is not related to Nanook, the master of the bears.

Similar Projects
----------------

There are several static website generators floating around. Some of them are like nanoc, and some of them aren’t similar at all. If nanoc doesn’t fulfill your needs, perhaps some of these do: [Hobix](http://hobix.com/), [Jekyll](http://github.com/mojombo/jekyll), [RakeWeb](http://rubyforge.org/projects/rakeweb/), [Rassmalog](http://rassmalog.rubyforge.org/), [Rog](http://rog.rubyforge.org/), [Rote](http://rote.rubyforge.org/), [RubyFrontier](http://www.apeth.com/RubyFrontierDocs/default.html), [StaticMatic](http://rubyforge.org/projects/staticmatic/), [StaticWeb](http://staticweb.rubyforge.org/), [Webby](http://webby.rubyforge.org/), [webgen](http://webgen.rubyforge.org/), [Yurt CMS](http://yurtcms.roberthahn.ca/), or [ZenWeb](http://www.zenspider.com/ZSS/Products/ZenWeb/).

Advantage #1: Fast
------------------

The main reason why nanoc was created, is to reduce the server load and improve page load times. After all, nothing gets served faster than a static HTML page.

Many CMSes (in its broadest sense) waste a lot of time. On each request, they fetch data from the database, then let a templating system merge the data with a page template, and finally send the assembled content to the site visitor's browser. Caching helps quite a bit, but not all CMSes do it well.

nanoc goes a step further than caching, and generates static files right away (you may call it "extreme caching" if you are so inclined). Using static files is not only fast--it also allows web browsers to cache files much more efficiently due to `Last-Modified` headers and such.

Advantage #2: Secure
--------------------

It wasn't a design goal, but it turns out that nanoc makes web pages a lot more secure.

Because nanoc does not run on the server itself, there is no way to exploit nanoc or Ruby, one way or another, in order to hack the site. Most CMSes do run on the server, which makes them a target for attacks.

Using nanoc is not a guarantee that your site will be unhackable, though. If your FTP account has a weak password, then you're asking for trouble. What I'm saying is that nanoc can't be blamed. :)

Advantage #3: Previewable
-------------------------

nanoc takes the pressure off going live.

When making changes to a live site, there is always the possibility that something will go wrong. Perhaps a typo in a SQL statement, a `div` that wasn't closed, etc. Whatever the reason is, visitors will temporarily see a site that is broken in some way.

When nanoc compiles a site, the compiled site goes into the `output` directory on the local computer. You can check every single page to make sure their contents are correct before uploading the site to the live server. That way, you're sure that nothing ever breaks.

Advantage #4: Versionable
-------------------------

The source files for a nanoc site are stored as flat text files by default. This means that you can easily store the site in a versioned repository (Subversion, Mercurial, git, darcs, Bazaar, etc.).

FIXME get rid of link to development section (and perhaps move it into the about page?)

Both the nanoc site and my personal web site, which are both built with nanoc, are versioned this way (they are publicly available from the nanoc repository--check the [Development](#development) section for details).

Advantage #5: Flexible
----------------------

A page in a nanoc site can have arbitrary metadata associated with it. This makes it quite easy to define custom page types. For example, you could create a blog post by setting the `kind` attribute to `article`, and then fetch all articles through `@items.select { |i| i[:kind] == 'article' }`. You can give a blog post tags, or you can give it an excerpt. Or, perhaps set `excerpt_length` and let nanoc generate the excerpt for you by taking a substring of the page content.

It is also possible to add custom code to a nanoc site. Simply create a Ruby file in the `lib` directory, put a function in there, and it'll be available when the site gets compiled. For example, this nanoc site has a `toc_for(item)` function for automatically generating the table of contents on the manual page.

Development
-----------

nanoc uses Mercurial as its VCS, and the repositories are located [over here](http://projects.stoneship.org/hg/). There is a [repository for nanoc itself](http://projects.stoneship.org/hg/nanoc), and there are repositories for sample sites and plugins. If you have any patches to share, I'd be happy to accept them!
