---

title:    "Documentation"
markdown: basic

---

The documentation for nanoc is organised in a couple of chapters, which you can see in the sidebar. The documentation is written with the intention to be read in-order, from the first chapter to the last.

The first chapter, [Introduction](/docs/1-introduction/), explains what nanoc is and what it does. The [Installation](/docs/2-installation/) and [Getting Started](/docs/3-getting-started) chapters detail how to start using nanoc. The [Basic Concepts](/docs/4-basic-concepts/), [Advanced Concepts](/docs/5-advanced-concepts) and [Guides](/docs/6-guides/) chapters explain all of nanoc’s functionality in detail and provide useful tips and tricks for getting the most out of nanoc. The [Glossary](/docs/7-glossary/) is useful if you don’t know what a certain term means, and the [FAQ](/docs/8-faq/) can come in handy if you’re stuck on a certain problem. Lastly, if you’re a nanoc 2.x user and you’re looking to update your site to nanoc 3.x, the [Migration guide](/docs/9-migrating-to-30/) will come in handy.

When you’re stuck with a question or a problem the documentation doesn’t solve, considering posting to the discussion group or joining the IRC channel. We’ll get it sorted out in no time. Check out the [Community](/community/) page for details.

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
