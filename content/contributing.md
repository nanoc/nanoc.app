---
title: "Contributing"
is_dynamic: true
---

nanoc is the effort of [dozens of people](#contributors). Contributions are welcomed, no matter how small. This page shows the different ways you can make a difference to nanoc.

Making a donation
-----------------

nanoc is, and always will be, provided free of charge. Development is voluntary and happens entirely in free time. If you use nanoc and like it, please consider showing your token of support by [making a donation](http://www.pledgie.com/campaigns/9282).

Reporting bugs
--------------

If you find a bug in nanoc, you should [report it](https://github.com/nanoc/nanoc/issues/new)! But before you do, make sure you have the latest version of nanoc (and dependencies) installed, and see if you can still reproduce the bug there. If you can, report it!

When reporting a bug, please make sure you include as many details as you can about the bug. Some information that you should include:

* The nanoc version (`nanoc --version`), including the Ruby version
* The `crash.log` file, if the bug you’re reporting is a crash
* Steps to reproduce the bug

Submitting feature requests
---------------------------

If you have an idea for a new feature, check whether or not it’s on the [nanoc Trello board](https://trello.com/b/dlEWOOBW/nanoc-4-0) yet. If it is not, start a discussion on the [nanoc Google group](https://groups.google.com/forum/?fromgroups#!forum/nanoc).

Reviewing pull requests
-----------------------

We use pull requests extensively for nanoc development. No pull request gets merged without at least one +1.

This approach ensures quality, but can be a bit slow. You can help out by checking pull requests marked as “to review”:

* [pull requests to review for nanoc](https://github.com/nanoc/nanoc/issues?labels=to+review)
* [pull requests to review for nanoc.ws](https://github.com/nanoc/nanoc.ws/issues?labels=to+review)

If you think the pull request is good, leave a `:+1:`. If you have concerns, leave a comment.

Contributing code
-----------------

To contribute code, ou need a basic knowledge of git. The [Try Git](http://try.github.io/) interactive tutorial is quite good for getting up to speed.

Before you start coding, make sure that the idea you have fits with nanoc’s philosophy. Start a thread on the [discussion group](http://groups.google.com/group/nanoc) or find us on the [IRC channel](irc://chat.freenode.net/#nanoc). Generally speaking, all bug fixes are accepted, while feature changes need more discussion.

NOTE: For all changes, backwards compatibility *must* be retained. This means that you can add a feature, but you cannot modify a feature to work in a different way.

To fetch the latest nanoc source code, clone the Git repository:

<pre><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd></pre>

Pick the right branch to start off:

* If you want to add a feature, use the `master` branch.
* If you want to add a bug fix, use the `release-3.6.x` branch.

You can switch to the right branch using `git checkout`:

<pre><span class="prompt">nanoc%</span> <kbd>git checkout release-3.6.x</kbd></pre>

Create a branch off one of the two existing branches mentioned above. Pick a good name; the convention is to prefix the branch name with `bug/` when it is a bug and with `feature/` if it is a feature. Once you’ve picked a branch name, create the branch:

<pre><span class="prompt">nanoc%</span> <kbd>git checkout -b bug/fix-colors-on-windows</kbd></pre>

nanoc uses [Bundler](http://bundler.io/) to manage its development dependencies. Run <kbd>bundle install</kbd> to install all dependencies necessary for development and testing.

Now you can make modifications to the source code. You can find the source code in <span class="filename">lib</span> and the tests in <span class="filename">test</span>. Make sure that your changes have test cases that cover the bug fix or the new/changed functionality. To run the tests, run <kbd>bundle exec rake</kbd>.

To test your locally modified version of nanoc on a local nanoc site, edit your site’s <span class="filename">Gemfile</span> and let the `nanoc` gem point to the locally modified version:

<pre><code class="language-ruby">gem 'nanoc', :path => '/home/denis/projects/nanoc'</code></pre>

NOTE: You can also invoke nanoc by calling <span class="command">nanoc</span> using the full path to the <span class="filename">bin/nanoc</span> in your cloned repository. However, we recommend using [Bundler](http://bundler.io/) instead.

After making your modifications, make sure that the source code documentation is up-to-date. nanoc uses [YARD](http://yardoc.org/) for its source code docs. The [YARD getting started guide](http://rubydoc.info/gems/yard/file/docs/GettingStarted.md) is a helpful resource when writing YARD documentation.

Finally, create a pull request. Make sure the submit your pull request against the branch you originally started off (`master` or `release-3.6.x`).

Once submitted, your work here is done. We’ll review the code, have a discussion and merge it once we’re satisfied.

Contributors
------------

These people have contributed to nanoc already:

<i><%= @items['/contributing/contributors/'].raw_content %></i>
