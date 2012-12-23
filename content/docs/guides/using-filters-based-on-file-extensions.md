---
title:    "Using filters based on file extensions"
has_toc:  true
markdown: basic
---

Using filters based on file extensions
--------------------------------------

Each item has an `:extension` attribute, containing the extension of the file that corresponds with the item. For example, an item with identifier /foo/ that is read from content/foo.md will have an `:extension` attribute with value `'md'`.

You can use this attribute in the Rules file. If you want to run filters based on file extensions, use a case/when statement on the file extension, like this:

<pre title="A sample compilation rule that filters based on file extension"><code class="language-ruby">compile '*' do
  case item[:extension]
    when 'md'
      filter :rdiscount
    when 'haml'
      filter :haml
  end
end</code></pre>
