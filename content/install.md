---
title:      "Install"
markdown:   basic
is_dynamic: true
has_toc:    true
---

Instructions For The Impatient
-----------------------------

Install nanoc using Rubygems, like this:

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

If that command results in permission errors, you likely need to be root:

<pre title="Installing nanoc as root"><span class="prompt">%</span> <kbd>sudo gem install nanoc</kbd></pre>

For detailed instructions, read on!

Installing Ruby
---------------

nanoc is written in [Ruby](http://ruby-lang.org/), so you will need to install a Ruby interpreter. Ruby 1.8.6 and up, including Ruby 1.9, is supported. You can even use one of the alternative Ruby implementations ([JRuby](http://jruby.org/), [Rubinius](http://rubini.us/), …) if you want to do so.

Ruby may already be installed on your system. To check, open a terminal window and type <kbd>ruby -v</kbd>; if you get “command not found” Ruby is not yet installed. Otherwise, you will see which version of Ruby you have e.g. Ruby 1.8.7 will return something like this:

<pre title="Checking whether Ruby is installed"><span class="prompt">%</span> <kbd>ruby -v</kbd>
<kbd>ruby 1.8.7 (2012-02-08 patchlevel 358) [your-operating-system-here]</kbd>
<span class="prompt">%</span> </pre>

If Ruby is not installed on your system yet, check out the [Ruby downloads page](http://www.ruby-lang.org/en/downloads/) to download a Ruby version for your system. Alternatively, if you have a Unix-like operating system, consider using [rvm](http://rvm.io), a tool that makes managing your Ruby installation(s) a whole lot easier.

Installing Rubygems
-------------------

Rubygems is Ruby’s package manager. With it, you can easily find and install new packages (called _gems_). While not _strictly_ necessary in order to use nanoc, it is greatly recommended to install Rubygems anyway.

It’s likely that you have Rubygems installed already. If you want to check whether you have Rubygems installed, open a terminal window and type <kbd>gem --version</kbd>. If that command prints a version number, Rubygems is installed. This is what it should look like:

<pre title="Checking whether Rubygems is installed"><span class="prompt">%</span> <kbd>gem --version</kbd>
<%= config[:gem_version_info] %>
<span class="prompt">%</span> </pre>

To install Rubygems, go to the [Rubygems download page](http://rubygems.org/pages/download) and follow the instructions there.

If you have Rubygems installed already, make sure you have a fairly recent version. I’ve tested nanoc with Rubygems 1.3.5 and up, so consider upgrading if you’re experiencing issues with an older Rubygems. The [Rubygems download page](http://rubygems.org/pages/download) also contains instructions for upgrading Rubygems.

Installing nanoc
----------------

All dependencies are now taken care of, and installing nanoc should now be easy:

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

Unless you use a Ruby manager such as [rvm](http://rvm.beginrescueend.com/), [rbenv](https://github.com/sstephenson/rbenv/) or [chruby](https://github.com/postmodern/chruby), this command may fail with a “permission denied” error. If this is the case, run the above command as root:

<pre title="Installing nanoc as root"><span class="prompt">%</span> <kbd>sudo gem install nanoc</kbd></pre>

To make sure that nanoc was installed correctly, run <kbd>nanoc --version</kbd>. It should print the version number along with some other information, like this:

<pre title="Checking whether nanoc is correctly installed"><span class="prompt">%</span> <kbd>nanoc --version</kbd>
<%= config[:nanoc_version_info] %>
<span class="prompt">%</span> </pre>

If you get a “command not found” error when trying to run `nanoc`, you may have to adjust your `$PATH` to include the path to the directory where Rubygems installs executables. For example, on Ubuntu the `$PATH` should include `/var/lib/gems/1.8/bin`.

The current version of nanoc is is <%= latest_release_info[:version] %>, released on <%= latest_release_info[:date].format_as_date %>. You can find the release notes for this version as well as release notes for older versions on the [release notes](/release-notes/) page.

If you’re on Windows and are using the Windows console, it’s probably a good idea to install the `win32console` gem using <kbd>gem install win32console</kbd> to allow nanoc to use pretty colors when writing stuff to the terminal.

### From git

You can also install nanoc from the repository if you want to take advantage of the latest features and improvements in nanoc. Be warned that the versions from the repository may be unstable, so it is recommended to install nanoc from rubygems if you want to stay safe. You can install nanoc from the git repository like this:

<pre title="Installing nanoc from the git repository"><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd>
<span class="prompt">~%</span> <kbd>cd nanoc</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem build nanoc.gemspec</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem install nanoc-*.gem</kbd></pre>
