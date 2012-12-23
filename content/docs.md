---

title:      "Documentation"
markdown:   basic
is_dynamic: true
child_desc: "nanoc documentation"

---

<% content_for :details do %>
    <h3>Documentation Index</h3>
    <ol>
	<li><%= link_to_id '/docs/tutorial/' %></li>
	<li><%= link_to_id '/docs/using-nanoc/' %></li>
	<li><%= link_to_id '/docs/extending-nanoc/' %></li>
	<li><%= link_to_id '/docs/guides/' %></li>
	<li><%= link_to_id '/docs/glossary/' %></li>
	<li><a href="/docs/api/current/">API documentation</a></li>
    </ol>
<% end %>

How to use the documentation
----------------------------

The documentation for nanoc is organised in a couple of parts:

1. The [Tutorial](/docs/tutorial/) chapter is meant for first-time users of nanoc, who want to get an impression of what nanoc can do and how it’s done. After reading this part, you should be able to get a basic site up and running.

2. The [Using nanoc](/docs/using-nanoc/) chapter describes how to use nanoc in great detail. Everything that nanoc can do, you will find in here.

3. The [Extending nanoc](/docs/extending-nanoc/) chapter shows how nanoc can be extended by writing custom helpers, filters, data sources and more. Medium-sized to large projects will certainly benefit from this chapter.

4. The [Guides](/docs/guides/) show in detail how specific things can be achieved with nanoc. Even if they are not relevant to you, they may be an interesting read in order to get a better idea of what the nanoc way is.

5. The [API documentation](/docs/api/current/) contains the documentation of nanoc’s internals. This is quite useful if you want to contribute to nanoc or extend it.

6. The [Glossary](/docs/glossary/) is a collection of terms that you may stumble upon while using nanoc or reading its documentation. If you don’t understand a term, go here!

When you’re stuck with a question or a problem the documentation doesn’t solve, considering posting to the <a href="#">discussion group</a> or joining the <a href="irc://irc.freenode.net/#nanoc">nanoc IRC channel</a>. We’ll get it sorted out in no time. Check out the [Community](/community/) page for details.

Markup conventions
------------------

The nanoc documentation uses a few conventions for markup:

* <i>Italic text</i> introduces new terms.
* <code>Monospaced text</code> is used for code snippets.
* <kbd>Monospaced, bold text</kbd> is used for commands that should be typed literally.
* <var>Monospaced, italic text</var> is used for text that should be replaced with user-supplied values.

The documentation also contains quite a few blocks of code snippets. These are marked up like this:

<pre title="Title of the snippet"><code class="language-ruby">class Lorem::Ipsum
  def dolor
    [ :foo, "sit amet, consectetur adipisicing elit", 123 ]
  end
end</code></pre>

Pieces of terminal input/output are marked up in a similar way. Note that the prompt is always included, but should never be typed. Here’s an example:

<pre title="Title of the snippet"><span class="prompt">some-dir%</span> <kbd>echo "hello" &amp;&amp; cd other-dir</kbd>
hello
<span class="prompt">other-dir%</span></pre>
