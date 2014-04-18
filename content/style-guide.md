---
title: Style guide
---

This page is designed to collect all the different elements used on the nanoc web site.

## Block-level elements

### Paragraphs

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### Blockquote

> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor.

### Preformatted text

Some code:

	#!ruby
	def say_hi_to(person, params = {})
	  puts("What’s up, #{person.first_name}?")
	rescue
	  puts("Uh… hi?")
	end

Some terminal input and output:

<pre><span class="prompt">~%</span> <kbd>bundle exec nanoc</kbd>
Loading site data… done
Compiling site…

Site compiled in 26357.65s.</pre>

### Unordered lists

These are short lists (no paragraphs):

* A short but cute
	* unordered list
	* with exactly
* five
* elements

These are long lists (with paragraphs):

* Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

* Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor.

### Ordered lists

These are short lists (no paragraphs):

1. An ordered list
2. with three
3. elements
	1. and even
	2. some sub-elements
4. followed by a root-level element

These are long lists (with paragraphs):

1. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

2. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor.

### Definition lists

nanoc
: A tool for generating static sites

DSL
: Domain-specific language
: Digital subscriber line

moshi
mothersip
: Something scary

### Admonitions

Here is a tip:

TIP: Prefix lines with `TIP:` to turn them into tip admonitions.

Here is a note:

NOTE: Admonitions are handled by a nanoc filter and not by Markdown.

Here is a caution:

CAUTION: The <span class="command">rm</span> command can cause data loss.

Here is a to-do item:

TODO: Finish this section.

### Figures

<figure class="fullwidth">
	<img src="/assets/images/tutorial/default-site.png" alt="Screenshot of what a brand new nanoc site looks like">
	<figcaption>Screenshot of what a brand new nanoc site looks like</figcaption>
</figure>

## Inline elements

link
: The <a href="http://nanoc.ws/">nanoc web site</a> is pretty.

emphasis
: You should <em>never</em> have to reboot your computer after installation.

strong emphasis
: You should <strong>never</strong> have a passwordless root account.

command
: The <span class="command">compile</span> command is used to compile a site.

user input
: To use it, type <kbd>nanoc compile</kbd> into the terminal.

replaceable text
: Replace <var>repo-url</var> with the URL of the repository.

abbreviation
: Be elegant (and maybe incomprehensible) with Ruby <abbr title="domain specific language">DSL</abbr>s.

first term
: To achieve this goal, we use the <span class="firstterm">outdatedness checker</span>.

code
: The `def` keyword is used to define a function or method.

filename
: Open the <span class="filename">content/index.md</span> file.

product name
: We love the <span class="productname">cri</span> library for building command-line interfaces.

URI
: Go to <span class="uri">http://example.com/</span> to see a sample web page.

highlighted text
: I love <mark>kitten</mark>s, and that is why I have 21!

TODO: Use the `dfn` tag instead of a `span` with the `firstterm` class.
