---
title:      "Install"
is_dynamic: true
---

Instructions For The Impatient
-----------------------------

Install nanoc using RubyGems, like this:

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

NOTE: {sudo-gem-install}

For detailed instructions, read on!

Installing Ruby
---------------

nanoc is written in [Ruby](http://ruby-lang.org/), so you will need to install a Ruby interpreter. Ruby 1.8.6 up to Ruby 2.1 are supported. You can also use alternative Ruby implementations such as [JRuby](http://jruby.org/) and [Rubinius](http://rubini.us/) if you want to do so.

Ruby may already be installed on your system. To check, open a terminal window and type <kbd>ruby --version</kbd>. If you get “command not found”, Ruby is not yet installed. Otherwise, you will see which version of Ruby you have:

<pre title="Checking whether Ruby is installed"><span class="prompt">%</span> <kbd>ruby --version</kbd>
<%= config[:ruby_version_info] %>
<span class="prompt">%</span> </pre>

To install Ruby, you have a few different options. You can use your operating system’s package manager, e.g. <kbd>sudo apt-get install ruby1.9.1</kbd> on Debian and Ubuntu, or <kbd>sudo pacman -S ruby</kbd> on Arch Linux. On Windows, you can use [RubyInstaller](http://rubyinstaller.org/). For OS X, we recommend using [Homebrew](http://brew.sh/)—a <kbd>brew install ruby</kbd> will install the latest Ruby version. On other Unix-like operating systems, [chruby](https://github.com/postmodern/chruby), [rbenv](http://rbenv.org/) or [rvm](http://rvm.io/) are a good choice. Alternatively, you can [download the Ruby source code](https://www.ruby-lang.org/en/downloads/) and compile it yourself.

Installing RubyGems
-------------------

RubyGems is Ruby’s package manager. With it, you can easily find and install new packages (called _gems_). While not _strictly_ necessary in order to use nanoc, it is greatly recommended to install RubyGems anyway.

It is likely that you have RubyGems installed already. To find out whether RubyGems is installed, type <kbd>gem --version</kbd>. If that command prints a version number, RubyGems is installed:

<pre title="Checking whether RubyGems is installed"><span class="prompt">%</span> <kbd>gem --version</kbd>
<%= config[:gem_version_info] %>
<span class="prompt">%</span> </pre>

To install RubyGems, go to the [RubyGems download page](http://rubygems.org/pages/download) and follow the instructions there.

Be sure what you have a fairly recent version of RubyGems. When in doubt, update your RubyGems:

<pre title="Updating RubyGems"><span class="prompt">%</span> <kbd>gem update --system</kbd>
Latest version currently installed. Aborting.
<span class="prompt">%</span> </pre>

NOTE: {sudo-gem-update-system}

NOTE: The <kbd>gem update --system</kbd> command is disabled on Debian and Ubuntu. On these distributions, you should use <code>apt</code> to upgrade Ruby and RubyGems.

Installing nanoc
----------------

All dependencies are now taken care of, and installing nanoc should now be easy:

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

NOTE: {sudo-gem-install}

To make sure that nanoc was installed correctly, run <kbd>nanoc --version</kbd>. It should print the version number along with some other information, like this:

<pre title="Checking whether nanoc is correctly installed"><span class="prompt">%</span> <kbd>nanoc --version</kbd>
<%= config[:nanoc_version_info] %>
<span class="prompt">%</span> </pre>

If you get a “command not found” error when trying to run `nanoc`, you might have to adjust your `$PATH` to include the path to the directory where RubyGems installs executables.

The current version of nanoc is is <%= latest_release_info[:version] %>, released on <%= latest_release_info[:date].format_as_date %>. You can find the release notes for this version as well as release notes for older versions on the [release notes](/release-notes/) page.

If you’re on Windows and are using the Windows console, it’s probably a good idea to install the `win32console` gem using <kbd>gem install win32console</kbd> to allow nanoc to use pretty colors when writing stuff to the terminal.

### From git

You can also install nanoc from the repository if you want to take advantage of the latest features and improvements in nanoc. Be warned that the versions from the repository may be unstable, so it is recommended to install nanoc from rubygems if you want to stay safe. You can install nanoc from the git repository like this:

<pre title="Installing nanoc from the git repository"><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd>
<span class="prompt">~%</span> <kbd>cd nanoc</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem build nanoc.gemspec</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem install nanoc-*.gem</kbd></pre>
