---
title: "Installation"
nav_title: "Install"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

Install nanoc using RubyGems:

<pre title="Installing nanoc"><span class="prompt">%</span> <kbd>gem install nanoc</kbd></pre>

NOTE: {sudo-gem-install}

For detailed instructions, read on!

## Installing Ruby

nanoc requires [Ruby](http://ruby-lang.org/) in order to run. nanoc supports the official Ruby interpreter from version 2.0 up, as well as JRuby from version 9000 up.

Ruby may already be installed on your system. To check, open a terminal window and type <kbd>ruby --version</kbd>. If you get “command not found”, Ruby is not yet installed. Otherwise, you will see which version of Ruby you have:

<pre title="Checking whether Ruby is installed"><span class="prompt">%</span> <kbd>ruby --version</kbd>
<%= config[:ruby_version_info] %>
<span class="prompt">%</span> </pre>

To install Ruby, follow the [installation instructions on the Ruby web site](https://www.ruby-lang.org/en/documentation/installation/).

## Installing nanoc

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

### Installing from git

You can also install nanoc from the repository if you want to take advantage of the latest features and improvements in nanoc. Be warned that the versions from the repository may be unstable, so it is recommended to install nanoc from rubygems if you want to stay safe. You can install nanoc from the git repository like this:

<pre title="Installing nanoc from the git repository"><span class="prompt">~%</span> <kbd>git clone git://github.com/nanoc/nanoc.git</kbd>
<span class="prompt">~%</span> <kbd>cd nanoc</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem build nanoc.gemspec</kbd>
<span class="prompt">~/nanoc%</span> <kbd>gem install nanoc-*.gem</kbd></pre>
