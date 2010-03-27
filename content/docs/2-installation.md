---

title:                 "Installation"
markdown:              basic
toc_includes_sections: true
is_dynamic:            true

---

Installing Ruby
---------------

nanoc is written in [Ruby](http://ruby-lang.org/), so you will need to install a Ruby interpreter. Ruby 1.8.6 and up, including Ruby 1.9, is supported. You can even use one of the alternative Ruby implementations ([JRuby](http://jruby.org/), [Rubinius](http://rubini.us/), …) if you want to do so.

You may have Ruby installed already. To check whether Ruby is installed on your system, open a terminal window and type <kbd>irb</kbd>; if you get a “command not found” then Ruby is not yet installed. This is what it should look like (hit <kbd>⌃D</kbd> or type <kbd>quit</kbd> to exit from `irb`):

<pre title="Checking whether Ruby is installed"><span class="prompt">%</span> <kbd>irb</kbd>
ruby-1.9.1-p378 > <kbd>quit</kbd>
<span class="prompt">%</span> </pre>

If Ruby is not installed on your system yet, check out the [Ruby downloads page](http://www.ruby-lang.org/en/downloads/) to download a Ruby version for your system.

Installing Rubygems
-------------------

Rubygems is Ruby’s package manager. With it, you can easily find and install new packages (called _gems_). While not _stricly_ necessary in order to use nanoc, it is greatly recommended to install Rubygems anyway.

It’s likely that you have Rubygems installed already. If you want to check whether you have Rubygems installed, open a terminal window and type <kbd>gem --version</kbd>. If that command prints a version number, Rubygems is installed. This is what it should look like:

<pre title="Checking whether Rubygems is installed"><span class="prompt">%</span> <kbd>gem --version</kbd>
1.3.5
<span class="prompt">%</span> </pre>

To install Rubygems, go to the [Rubygems download page](http://rubygems.org/pages/download) and follow the instructions there.

Installing nanoc
----------------

All dependencies are now taken care of, and installing nanoc should now be as easy as this (you may have to prefix the <kbd>gem</kbd> command with <kbd>sudo</kbd> to ensure that you’re using root privileges):

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

To make sure that nanoc was installed correctly, run <kbd>nanoc --version</kbd>. It should print the version number along with some other information, like this:

<pre title="Checking whether nanoc is correctly installed"><span class="prompt">%</span> <kbd>nanoc --version</kbd>
nanoc 3.1.0 (c) 2007-2010 Denis Defreyne.
Ruby 1.9.1 (2010-01-10) running on i386-darwin10.2.0
<span class="prompt">%</span> </pre>

If you get a “command not found” error when trying to run `nanoc`, you may have to adjust your `$PATH` to include the path to the directory where Rubygems installs executables. For example, on Ubuntu the `$PATH` should include `/var/lib/gems/1.8/bin`.

The current version of nanoc is is <%= latest_release_info[:version] %>, released on <%= latest_release_info[:date].format_as_date %>. You can find the release notes for this version as well as release notes for older versions on the [release notes](/release-notes/) page.
