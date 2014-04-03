---
title:    "Unit testing nanoc sites"
---

The `check` command
-------------------

New in nanoc 3.5 is a <kbd>check</kbd> command that can be used to verify that the compiled site meets the requirements. Five checks are built-in to nanoc: `css`, `html`, `external_links` (or `elinks`), `internal_links` (or `ilinks`), and `stale` (the latter verifies whether no non-nanoc items are in the output directory).

A check can be run using <kbd>nanoc check <var>check-name</var></kbd>. For instance, the following will run the internal links check (`internal_links` or `ilinks`):

<pre title="Running a check"><span class="prompt">%</span> <kbd>nanoc check ilinks</kbd>
Loading site data… done
  Running internal_links check…   ok
<span class="prompt">%</span></pre>

Deployment-time checks
----------------------

A file named `Checks` at the root of a nanoc site can define which checks should be run before a <kbd>nanoc deploy</kbd>. Here is what a Checks file could look like:

<pre title="Defining checks to be run before deployment"><code class="language-ruby">
deploy_check :internal_links
deploy_check :stale
</code></pre>

These checks will be performed before deploying. Here’s what a <kbd>nanoc deploy</kbd> looks like with a Checks file:

<pre title="Deploying with a Checks file"><span class="prompt">%</span> <kbd>nanoc deploy</kbd>
Loading site data… done
Running issue checks…
  Running internal_links check…       ok
  Running stale check…                ok
  Running no_unprocessed_erb check…   ok
No issues found. Deploying!
<span class="prompt">%</span></pre>

To run the checks marked for deployment without deploying, use <kbd>nanoc check \--deploy</kbd>.

Custom checks
-------------

The `Checks` file is also used to define custom checks. Here is an example check that verifies that no compiled files contain <code>&lt;%</code> and therefore likely include unprocessed ERB instructions:

<pre title="Defining a custom check"><code class="language-ruby">
check :no_unprocessed_erb do
  self.output_filenames.each do |fn|
    if fn =~ /html$/ &amp;&amp; File.read(fn).match(/&lt;%/)
      self.add_issue("erb detected", :subject => fn)
    end
  end
end
</code></pre>

In a custom check, you can use `#add_issue`. The first argument is the description of the problem, and the `:subject` option defines the location of the problem (usually a filename).

The following data methods are available in a custom check:

`output_filenames`
: A list of filenames in the output directory corresponding to items. This list
  does not include files that are in output but do not have a corresponding item.

`site`
: The [Nanoc::Site](/docs/api/Nanoc/Site.html) instance representing the current
  site. To get the items, layouts or configuration, use `#items`, `#layouts` and
  `#config`, respectively.
