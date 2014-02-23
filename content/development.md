---
title:    "Development"
markdown: basic
---

Reporting bugs
--------------

If you find a bug in nanoc, you should [report it](https://github.com/nanoc/nanoc/issues/new)! But before you do, make sure you have the latest version of nanoc (and dependencies) installed, and see if you can still reproduce the bug there. If you can, report it!

When reporting a bug, please make sure you include as many details as you can about the bug. Some information that you should include:

* The nanoc version (`nanoc --version`), including the Ruby version
* The `crash.log` file, if the bug you’re reporting is a crash
* Steps to reproduce the bug

Submitting feature requests
---------------------------

If you have an idea for a feature that you believe is missing in nanoc, describe it on the [wishlist](https://github.com/nanoc/nanoc/wiki/Wishlist). I recommend also starting a discussion on the [discussion forums](https://groups.google.com/forum/?fromgroups#!forum/nanoc) to get feedback.

The GitHub issue tracker is is used to track development of new features. Take a look at the [list of open features](https://github.com/nanoc/nanoc/issues?labels=feature&state=open). A bunch of old features are still described in the [repository for nanoc enhancement proposals](https://github.com/nanoc/neps), but it is expected that these will be migrated to GitHub issues some time soon.

Contributing code
-----------------

### Prerequisites

First of all, you need a basic knowledge of git. The [Try Git](http://try.github.io/) interactive tutorial is quite good for getting up to speed.

Before you start, it is worth double-checking whether what you have in mind is a good idea and would fit in nanoc. Start a thread on the [discussion group](http://groups.google.com/group/nanoc) or find us on the [IRC channel](irc://chat.freenode.net/#nanoc). Generally speaking, all bug fixes are accepted, while feature changes need more discussion. Note that no matter what, backwards compatibility *must* be retained. This means that you cannot modify a feature to work in a different way.

### Clone

If you want to contribute code, the first thing to do is get the latest source code from git. The nanoc source code is available in the [nanoc repository on GitHub](https://github.com/nanoc/nanoc). Clone it:

<pre title="Cloning the nanoc git repository"><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd></pre>

### Pick the right branch

Once you have the repository, you need to pick the right branch to start off:

* The `master` branch contains new developments that are scheduled to be released in the next feature release (x.Y.0 release). If your contribution is a new feature or extends an existing feature, use this branch.

* The `release-*` branches, e.g. `release-3.6.x`, are branched off the master branch when the feature set is frozen. Bug fixes are applied on this branch and will be part of the next bugfix release (x.y.Z release). If your contribution is a bug fix, use this branch.

You can switch to the right branch using `git checkout`:

<pre title="Switching to the existing release-3.6.x branch"><span class="prompt">nanoc%</span> <kbd>git checkout release-3.6.x</kbd></pre>

### Create a feature or bugfix branch

Create a branch off one of the two existing branches mentioned above. Pick a good name; the convention is to prefix the branch name with `bug/` when it is a bug and with `feature/` if it is a feature. Once you’ve picked a branch name, create the branch:

<pre title="Creating a bug branch"><span class="prompt">nanoc%</span> <kbd>git checkout -b bug/fix-colors-on-windows</kbd></pre>

### Set up bundler

nanoc uses [Bundler](http://bundler.io/) to manage its development dependencies. Run <kbd>bundle install</kbd> to install all dependencies necessary for development and testing:

<pre title="Installing bundler"><span class="prompt">nanoc%</span> <kbd>bundle install</kbd>
Resolving dependencies...
Using rack (1.5.2)
Using adsf (1.2.0)
[snip]
Using yard (0.8.7.3)
Using bundler (1.3.5)
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.</pre>

### Modify the code

Now you can make modifications to the source code.

You can find the source code in `lib` and the tests in `test`. Make sure that your changes have test cases that cover the bug fix or the new/changed functionality. To run the tests, use <kbd>bundle exec rake</kbd>:

<pre title="Running the tests"><span class="prompt">nanoc%</span> <kbd>bundle exec rake</kbd>

Run options: --seed 2302

# Running tests:
[snip]</pre>

To test your locally modified version of nanoc on a local nanoc site, you can either <kbd>cd</kbd> into the site and invoke nanoc by specifying the full path to `bin/nanoc`, or, if you use Bundler, edit the `Gemfile` and let the `nanoc` gem point to the locally modified version:

<pre title="Specifying a custom path for Bundler"><code class="language-ruby">gem 'nanoc', :path => '/home/denis/projects/nanoc'</code></pre>

Make sure that the source code documentation is up-to-date. nanoc uses [YARD](http://yardoc.org/) for its source code docs. The [YARD getting started guide](http://rubydoc.info/gems/yard/file/docs/GettingStarted.md) is a helpful resource when writing YARD documentation.

Leave the `NEWS.md` and `lib/nanoc/version.rb` files untouched; they’ll be updated once a new release is about to be published.

### Submit pull request

When making a pull request, pay attention to which branch you want the changed to be pulled into:

* If your pull request is a bug fix, submit it on the latest `release-3.*` branch. This ensures that the bug fix comes in the next patch release.

* If your pull request is a new feature or extends an existing feature, submit it on the `master` branch.

Once submitted, your work here is done. We’ll review the code, have a discussion and merge it once we’re satisfied.
