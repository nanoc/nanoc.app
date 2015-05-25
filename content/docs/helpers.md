---
title: "Helpers"
is_dynamic: true
up_to_date_with_nanoc_4: true
---

A helper is a module with functions that can be used during filtering.

Helpers need to be activated before they can be used. To activate a helper, `include` it, like this (in a file in the <span class="filename">lib/</span> directory, such as <span class="filename">lib/helpers.rb</span>):

	#!ruby
	include Nanoc::Helpers::Blogging

Take a look at the [helpers reference](/docs/reference/helpers/) for a list of helpers that are included with nanoc.

Writing helpers
---------------

To write a helper, create a file in the <span class="filename">lib/</span> directory of the site. In that file, declare a module, and put your helpers methods inside that module.

For example, the file <span class="filename">lib/random_text.rb</span> could contain this:

	#!ruby
	module RandomTextHelper
	  def random_text
	    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do" \
	    "eiusmod tempor incididunt ut labore et dolore magna aliqua."
	  end
	end

To use this helper, `include` it, for instance in <span class="filename">lib/helpers.rb</span>:

	#!ruby
	include RandomTextHelper

The methods provided by this helper can now be used during filering. For example, the default layout, assuming it is filtered using ERB, can now generate random text like this:

	#!erb
	<p><%%= random_text %></p>

### Pitfall: helper load order

Files in the <span class="filename">lib/</span> directory are loaded alphabetically. This can cause nanoc to try to `include` a helper before it is loaded.

For example, this situation will arise if helpers live in a <span class="filename">lib/helpers/</span> directory, with the <span class="filename">lib/helpers.rb</span> file containing the `#include` calls:

<pre><span class="prompt">%</span> <kbd>tree lib</kbd>
lib
├── helpers.rb
└── helpers
    ├── link_to_id.rb
    └── toc.rb
</pre>

The <span class="filename">lib/helpers.rb</span> file will be loaded before anything in <span class="filename">lib/helpers/</span>, and will thus result in an error such as `NameError: uninitialized constant LinkToId`.

To resolve this problem, rename <span class="filename">lib/helpers.rb</span> to <span class="filename">lib/helpers_.rb</span>, so that it gets loaded after the helpers have loaded:

<pre><span class="prompt">%</span> <kbd>tree lib</kbd>
lib
├── helpers
│   ├── link_to_id.rb
│   └── toc.rb
└── helpers_.rb
</pre>
