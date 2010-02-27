---

title:                 "Introduction to nanoc"
markdown:              basic
is_dynamic:            true
toc_includes_sections: true

---

What is nanoc?
--------------

nanoc is a tool for building static web sites. It can transform content from one format (e.g. Haml or Markdown) into another (usually HTML) and lay out pages so that the site’s look and feel is consistent across all pages.

nanoc is not a true content management system (CMS), as it does not manage content—*you* manage the content, and nanoc processes it for you. nanoc does have some CMS-like functionality, such as finding items that have certain attributes associated with them; for example, running a query such as “find all articles by a given author” is possible.

Unlike many CMSes and blog engines, nanoc runs on your local computer, and not on the server. It doesn’t need to—nanoc produces static HTML files that can be uploaded to any web server. This also means that the server doesn’t need to have anything “special” installed at all—it just needs to be able to serve static files, which every web server can.

Similar Projects
----------------

There are several static website generators floating around. Some of them are like nanoc, and some of them aren’t similar at all. If nanoc doesn’t fulfill your needs, perhaps some of these Ruby ones do: [Bonsai](http://tinytree.info/), [Hobix](http://github.com/hobix/hobix/), [Jekyll](http://github.com/mojombo/jekyll), [Korma](http://github.com/sandal/korma), [Middleman](http://github.com/tdreyno/middleman), [RakeWeb](http://rubyforge.org/projects/rakeweb/), [Rassmalog](http://rassmalog.rubyforge.org/), [Rog](http://rog.rubyforge.org/), [Rote](http://rote.rubyforge.org/), [RubyFrontier](http://www.apeth.com/RubyFrontierDocs/default.html), [StaticMatic](http://rubyforge.org/projects/staticmatic/), [StaticWeb](http://staticweb.rubyforge.org/), [Webby](http://webby.rubyforge.org/), [webgen](http://webgen.rubyforge.org/), [Yurt CMS](http://yurtcms.roberthahn.ca/), or [ZenWeb](http://www.zenspider.com/ZSS/Products/ZenWeb/).

There are some non-Ruby ones around too: [Chisel](http://github.com/dz/chisel) (Python), [Hakyll](http://jaspervdj.be/hakyll/) (Haskell), [Hyde](http://github.com/lakshmivyas/hyde) (Python), [Pagegen](http://pagegen.phnd.net/) (Bash), [Tahchee](http://www.ivy.fr/tahchee/) (Python), [Ultra simple Site Maker](http://www.loup-vaillant.fr/projects/ussm/) (Ocaml), [Website Meta Language](http://www.thewml.org/) (C and Perl).

Advantages
----------

### Fast

Static pages load lightning fast.

The main reason why nanoc was created, is to reduce the server load and improve page load times. After all, nothing gets served faster than a static HTML page. Many CMSes (in its broadest sense) waste a lot of time. On each request, they fetch data from the database, then let a templating system merge the data with a page template, and finally send the assembled content to the site visitor’s browser. Caching helps quite a bit, but not all CMSes do it well.

nanoc goes a step further than caching, and generates static files right away (you may call it “extreme caching” if you are so inclined). Using static files is not only fast—it also allows web browsers to cache files much more efficiently due to `Last-Modified` headers and such.

### Safe

It is a lot safer to host a static web site than a dynamic one.

Because nanoc does not run on the server itself, there is no way to exploit nanoc or Ruby, one way or another, in order to hack the site. Most CMSes do run on the server, which certainly does makes them a target for attacks.

Using nanoc is not a guarantee that your site will be unhackable, though. If your FTP account has a weak password, then you’re asking for trouble. With nanoc you can still output dynamic files, such as PHP ones, and these pages could still be the cause of security issues.

### Previewable

nanoc takes the pressure off going live.

When making changes to a live site, there is always the possibility that something will go wrong. Perhaps a typo in a SQL statement, a `div` that wasn’t closed, etc. Whatever the reason is, visitors will temporarily see a site that is broken in some way.

When nanoc compiles a site, the compiled site goes into the `output` directory on the local computer. You can check every single page to make sure their contents are correct before uploading the site to the live server. That way, you’re sure that nothing ever breaks.

### Versionable

The source files for a nanoc site are stored as flat text files by default. This means that you can easily store the site in a versioned repository (Subversion, Mercurial, git, darcs, Bazaar, etc.).

Both the nanoc site and my personal web site, which are both built with nanoc, are versioned this way (they are publicly available from the nanoc repository—check the [Development](#development) section for details).

### Flexible

A page in a nanoc site can have arbitrary metadata associated with it. This makes it quite easy to define custom page types. For example, you could create a blog post by setting the `kind` attribute to `article`, and then fetch all articles through `@items.select { |i| i[:kind] == 'article' }`. You can give a blog post tags, or you can give it an excerpt. Or, perhaps set `excerpt_length` and let nanoc generate the excerpt for you by taking a substring of the page content.

It is also possible to add custom code to a nanoc site. Simply create a Ruby file in the `lib` directory, put a function in there, and it’ll be available when the site gets compiled. For example, this nanoc site has a `toc_for(item)` function for automatically generating the table of contents on the manual page.

Development
-----------

nanoc uses Mercurial as its VCS, and its main repository is located [over here](http://projects.stoneship.org/hg/nanoc). There is also a [mirror at GitHub](http://github.com/ddfreyne/nanoc) if you prefer git over hg. If you have any patches to share, I’d be happy to accept them!
