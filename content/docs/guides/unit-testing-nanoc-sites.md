---
title: "Testing nanoc sites"
short_title: "Testing"
up_to_date_with_nanoc_4: true
---

The <kbd>check</kbd> command is used to verify that a compiled site meets the requirements.

A check can be run using <kbd>nanoc check <var>check-name</var></kbd>. For instance, the following will run the internal links check (`internal_links` or `ilinks`):

<pre title="Running a check"><span class="prompt">%</span> <kbd>nanoc check ilinks</kbd>
Loading site data… done
  Running internal_links check…   ok
<span class="prompt">%</span></pre>

Available checks
----------------

nanoc comes with the following checks:

`css`
: verifies that the CSS is valid

`html`
: verifies that the HTML is valid

`external_links`
`elinks`
: verifies that external links are correct

`internal_links`
`ilinks`
: verifies that internal links are correct

`stale`
: verifies whether no non-nanoc items are in the output directory

`mixed_content`
: verifies that no content is included or linked to from a potentially insecure source

Deployment-time checks
----------------------

A file named <span class="filename">Checks</span> at the root of a nanoc site defines which checks should be run before a <kbd>nanoc deploy</kbd>.

Here is an example <span class="filename">Checks</span> file that ensures that a nanoc site does not get deployed if there are broken internal links or stale files in the output directory:

<pre><code class="language-ruby">
deploy_check :internal_links
deploy_check :stale
</code></pre>

Here’s what a <kbd>nanoc deploy</kbd> looks like when all checks pass:

<pre><span class="prompt">%</span> <kbd>nanoc deploy</kbd>
Loading site data… done
Running issue checks…
  Running internal_links check…   <span class="log-check-ok">ok</span>
  Running stale check…            <span class="log-check-ok">ok</span>
No issues found. Deploying!
<span class="prompt">%</span></pre>

Here’s what a <kbd>nanoc deploy</kbd> looks like when some checks fail:

<pre><span class="prompt">%</span> <kbd>nanoc deploy</kbd>
Loading site data… done
Running issue checks…
  Running check internal_links…   <span class="log-check-error">error</span>
  Running check stale…            <span class="log-check-ok">ok</span>
Issues found!
  output/docs/guides/unit-testing-nanoc-sites/index.html:
    [ <span class="log-check-error">ERROR</span> ] internal_links - broken reference to ../../api/Nanoc/Site.html
Issues found, deploy aborted.
<span class="prompt">%</span></pre>

To run the checks marked for deployment without deploying, use <kbd>nanoc check --deploy</kbd>.

Custom checks
-------------

The `Checks` file is also used to define custom checks. Here is an example check that verifies that no compiled files contain <code>&lt;%</code> and therefore likely include unprocessed ERB instructions:

<pre title="Defining a custom check"><code class="language-ruby">
check :no_unprocessed_erb do
  @output_filenames.each do |fn|
    if fn =~ /html$/ &amp;&amp; File.read(fn).match(/&lt;%/)
      add_issue("erb detected", :subject => fn)
    end
  end
end
</code></pre>

In a custom check, you can use `#add_issue`. The first argument is the description of the problem, and the `:subject` option defines the location of the problem (usually a filename).

In a custom check, the variables `@config`, `@items`, and `@layouts` are available, in addition to `@output_filenames`, which is the collection of filenames in the output directory that correspond to an item in the site. See the [variables](/docs/reference/variables/) page for details.
