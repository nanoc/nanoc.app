---
title:      "About nanoc"
markdown:   basic
is_dynamic: true
has_toc:    true
---

What is nanoc?
--------------

nanoc is a tool for building static web sites. It can transform content from one format (e.g. Haml or Markdown) into another (usually HTML) and lay out pages so that the site’s look and feel is consistent across all pages.

nanoc is not a true content management system (CMS), as it does not manage content—*you* manage the content, and nanoc processes it for you. Some CMS-like functionality, such as finding items that have certain attributes associated with them, is present in nanoc, though; for example, running a query such as “find all articles by a given author” is possible.

Unlike many CMSes and blog engines, nanoc runs on your local computer, and not on the server. It doesn’t need to—nanoc produces static HTML files that can be uploaded to any web server. This also means that the server doesn’t need to have anything “special” installed at all—it just needs to be able to serve static files, which every web server can.

History
-------

Around 2006, I was looking for a Ruby blog engine. However, having a VPS with only 96 MB of RAM, any Ruby-based CMS ran _extremely_ slowly. When a friend of mine showed his web site consisting only of static files, I decided to take that route as well, and ended up with a script with basic Markdown and ERB support; the first version of nanoc, released in April 2007.

nanoc has grown quite a bit since then. While the first version of nanoc could be considered more as a set of interacting scripts, nanoc 2.0 was designed to be an actual application, while retaining the spirit of nanoc 1.0. A bit later, in 2009, nanoc 3.0 followed, introducing the concept of the `Rules` file, allowing filters and layouts to be specified in a DRYer and more flexible way. nanoc 3.x is still actively being developed, with feature releases every six months and bug fix releases whenever they are necessary.

Why use nanoc?
--------------

nanoc is suitable for all sorts of sites. It is usable for small personal weblogs, portfolios, product web sites and more. It has been used in production for such sites. All web sites that do not need to allow user-contributed content through a web interface can be built with nanoc.

nanoc is not a simplistic web site publishing tool. It is aimed at being both powerful and flexible. While other static web site publishing tools focus on providing only a handful of features, nanoc aims to be capable of building all sorts of sites.

Extending nanoc is easy because of its modular architecture. It comes with only a couple of extensions, thereby avoiding bloat, but allows new functionality to be plugged in quickly and easily. A well-documented API is what makes nanoc powerful and flexible.

The target audience of nanoc is Rubyists with some level of Ruby experience. It does not hide its Ruby roots, as doing so would make it a lot less powerful. This does mean, however, that people new to Ruby will maybe not find nanoc to be the easiest static site generation tool out there.

Why Static?
-----------

Why use a static site generator instead of a powerful server-side content management system? Here are some reasons why using a server-side CMS may not be the right choice for you:

### Fast

Static pages load lightning fast.

The main reason why nanoc was created, is to reduce the server load and improve page load times. After all, nothing gets served faster than a static HTML page. Many CMSes (in its broadest sense) waste a lot of time. On each request, they fetch data from the database, then let a templating system merge the data with a page template, and finally send the assembled content to the site visitor’s browser. Caching helps quite a bit, but not all CMSes do it well.

nanoc goes a step further than caching, and generates static files right away (you may call it “extreme caching” if you are so inclined). Using static files is not only fast—it also allows web browsers to cache files much more efficiently due to `Last-Modified` headers and such.

### Safe

It is a lot safer to host a static web site than a dynamic one.

Because nanoc does not run on the server itself, there is no way to exploit nanoc or Ruby, one way or another, in order to hack the site. Most CMSes do run on the server, which certainly makes them a target for attacks.

Using nanoc is not a guarantee that your site will be unhackable, though. If your FTP account has a weak password, then you’re asking for trouble. With nanoc you can still output dynamic files, such as PHP ones, and these pages could still be the cause of security issues.

### Previewable

nanoc takes the pressure off going live.

When making changes to a live site, there is always the possibility that something will go wrong. Perhaps a typo in a SQL statement, a `div` that wasn’t closed, etc. Whatever the reason is, visitors will temporarily see a site that is broken in some way.

When nanoc compiles a site, the compiled site goes into the `output` directory on the local computer. You can check every single page to make sure their contents are correct before uploading the site to the live server. That way, you’re sure that nothing ever breaks.

### Versionable

The source files for a nanoc site are stored as flat text files by default. This means that you can easily store the site in a versioned repository (Subversion, Mercurial, git, darcs, Bazaar, etc.).

Both the nanoc site and my personal web site, which are both built with nanoc, are versioned this way (they are publicly available from the nanoc repository—check the [Development](/development/) section for details).

Similar Projects
----------------

There are several static website generators floating around. Some of them are like nanoc, and some of them aren’t similar at all. If nanoc doesn’t fulfill your needs, perhaps some of these do:

<ul>
<% @items.select { |i| i.identifier =~ %r{^/about/ssgs/} }.sort_by { |i| i[:name].downcase }.each do |i| %>
<% url = i[:website] || (i[:github] ? 'http://github.com/' + i[:github] : nil ) %>
<li>
    <% if url %><a href="<%=h url %>"><% end %><%= i[:name] %><% if url %></a><% end %>&nbsp;(<%= i[:language] %>)
</li>
<% end %>
</ul>
