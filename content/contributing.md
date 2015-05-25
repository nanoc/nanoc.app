---
title: "Contributing"
is_dynamic: true
up_to_date_with_nanoc_4: true
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

This approach ensures quality, but can be a bit slow. You can help out by checking [open pull requests marked as “to review”](https://github.com/pulls?q=is%3Aopen+user%3Ananoc+label%3A%22to+review%22).

If you think the pull request is good, leave a `:+1:`. If you have concerns, leave a comment.

Contributing code
-----------------

To contribute code, you need a basic knowledge of git. The [Try Git](http://try.github.io/) interactive tutorial is quite good for getting up to speed.

Before you start coding, make sure that the idea you have fits with nanoc’s philosophy. Start a thread on the [discussion group](http://groups.google.com/group/nanoc) or find us on the [IRC channel](irc://chat.freenode.net/#nanoc). Generally speaking, all bug fixes are accepted, while feature changes need more discussion.

NOTE: For all changes, backwards compatibility *must* be retained. This means that you can add a feature, but you cannot modify a feature to work in a different way.

To fetch the latest nanoc source code, clone the Git repository:

<pre><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd></pre>

Pick the right branch to start off:

* If you want to add a feature, use the `master` branch.
* If you want to add a bug fix, use the `release-3.7.x` branch.

You can switch to the right branch using `git checkout`:

<pre><span class="prompt">nanoc%</span> <kbd>git checkout release-3.7.x</kbd></pre>

Create a branch off one of the two existing branches mentioned above. Pick a good name; the convention is to prefix the branch name with `bug/` when it is a bug and with `feature/` if it is a feature. Once you’ve picked a branch name, create the branch:

<pre><span class="prompt">nanoc%</span> <kbd>git checkout -b bug/fix-colors-on-windows</kbd></pre>

nanoc uses [Bundler](http://bundler.io/) to manage its development dependencies. Run <kbd>bundle install</kbd> to install all dependencies necessary for development and testing.

Now you can make modifications to the source code. You can find the source code in <span class="filename">lib</span> and the tests in <span class="filename">test</span>. Make sure that your changes have test cases that cover the bug fix or the new/changed functionality. To run the tests, run <kbd>bundle exec rake</kbd>.

To test your locally modified version of nanoc on a local nanoc site, edit your site’s <span class="filename">Gemfile</span> and let the `nanoc` gem point to the locally modified version:

<pre><code class="language-ruby">gem 'nanoc', :path => '/home/denis/projects/nanoc'</code></pre>

NOTE: You can also invoke nanoc by calling <span class="command">nanoc</span> using the full path to the <span class="filename">bin/nanoc</span> in your cloned repository. However, we recommend using [Bundler](http://bundler.io/) instead.

After making your modifications, make sure that the source code documentation is up-to-date. nanoc uses [YARD](http://yardoc.org/) for its source code docs. The [YARD getting started guide](http://rubydoc.info/gems/yard/file/docs/GettingStarted.md) is a helpful resource when writing YARD documentation.

Finally, create a pull request. Make sure the submit your pull request against the branch you originally started off (`master` or `release-3.7.x`).

Once submitted, your work here is done. We’ll review the code, have a discussion and merge it once we’re satisfied.

Releasing nanoc
---------------

If you’re a release manager, you can follow these steps to release a new version of nanoc. Before you start, make sure that you’ve got the approval of at least one other release manager (and preferably also the approval of Denis).

CAUTION: Being a release manager grants you considerable power, but remember that with great power comes great responsibility.

### Preparing for a release

Preparing a release means ensuring that the version that is about to be released meets the requirements. To prepare for a release, follow these steps:

1. Ensure the `Nanoc::VERSION` constant is set to the right version. Keep in mind that nanoc follows the [Semantic Versioning](http://semver.org/) standard.

2. Ensure the release notes in the <span class="filename">NEWS.md</span> file are up-to-date, and that the release date is correct.

3. Run the tests using <kbd>bundle exec rake</kbd>.

4. As a final check, compile the nanoc site with the nanoc gem in the <span class="filename">Gemfile</span> pointing to your local nanoc working copy, and verify locally that the release notes page is as expected.

5. Make sure you have received the permissions to do all of the steps below. If you haven’t , let me (Denis) know and I’ll set you up. You’ll need GitHub push privileges, RubyGems push privileges, IRC channel operator access, and web site push access.

### Releasing the new version

Once the preparation is complete, the new version can be released. To release a new version of nanoc, follow these steps:

1. Build the gem (<kbd>gem build nanoc.gemspec</kbd>).

2. Tag the release using <kbd>git tag --sign --annotate <var>1.2.3</var> --message 'Version <var>1.2.3</var>'</kbd>, replacing <var>1.2.3</var> with the new version number. Signing Git tags is optional, but highly recommended.

3. Push the gem using <kbd>gem push nanoc-*.gem</kbd>.

4. Push the changes to GitHub (<kbd>git push</kbd>). Don’t forget to also push the tags (<kbd>git push --tags</kbd>).

### Spread the word

To announce the new release, follow these steps:

1. Update the release notes on site. This only involves recompiling the site with the new version of nanoc (the release notes on the site are extracted from the <span class="filename">NEWS.md</span> file in the nanoc gem) and pushing the site (<kbd>bundle exec nanoc deploy</kbd>).

2. Update the release notes on GitHub. Create a new release for the tag, set the release title to the new version number, and copy-paste the release notes into the description field.

3. Send an announcement e-mail to the [nanoc mailing list](http://groups.google.com/group/nanoc). Include the version number, link to the release notes, instructions for how to update (using plain Rubygems and using Bundler), and instructions on how to report issues. The e-mail template that I often use is based off the following:

   <pre class="template">Hi,

   nanoc <var>version</var> is out. This <var>major/minor/patch</var> release <var>fixes a bug related to X/adds enhancements X and Y/adds feature X</var>. You can find the full release notes at the bottom of this e-mail or at http://nanoc.ws/release-notes/.

   You can update your gems using `gem update`. If you use Bundler (which I recommend), run `bundle update` to get the latest version of nanoc.

   Do report any bugs you find on the GitHub issue tracker at https://github.com/nanoc/nanoc/issues/new.

   Cheers,

   Denis

   <var>RELEASE NOTES</var></pre>

4. Update the topic of the <i>#nanoc</i> IRC channel.

Contributors
------------

These people have contributed to nanoc already:

<i><%= @items['/contributing/contributors'].raw_content %></i>
