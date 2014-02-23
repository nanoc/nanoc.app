---
title:    "Paginating articles"
markdown: basic
---

A Word of Caution
-----------------

First, a word of caution: I am not a fan of paginating items. Even though pagination is fairly easy to do in nanoc, I recommend not doing it, for one specific reason. Every time an object is added to a paginated collection, one object shifts from one page to the next. When a paginated page is bookmarked, it may show entirely different content a month later, and when a paginated page turns up as a result on a search engine, it may no longer contain the content that the person was looking for anymore. To avoid these issues, I recommend creating separate pages for each category, tag or year. Having said all this, I’ll nonetheless show you how to do pagination in nanoc, so you can get an idea of how it can be done.

Implementation
--------------

To paginate articles, we’ll use the preprocessor block in the Rules file. The preprocessor contains code that will be executed before the site is compiled, but after the site data (items, layouts, etc) have been loaded. This is the ideal moment to create new items (which is what we will be doing) or modify or delete existing ones. The preprocessor block will look like this:

<pre title="A preprocessor block that still needs to be filled in"><code class="language-ruby">preprocess do
  def paginate_articles
    # code will go here
  end

  paginate_articles
end</code></pre>

Like the snippet says, the actual code for paginating the articles will go in the #paginate_articles method that is defined inside the preprocess block. The code could go directly in the preprocess block, with no method definitions or calls, like this:

<pre title="A simpler preprocessor block that still needs to be filled in"><code class="language-ruby">preprocess do
  # code will go here
end</code></pre>

…but if your preprocessor block grows, it’s quite useful to separate different tasks in different methods. It’s also possible to store the method definitions in the lib/ directory somewhere, allowing the preprocessor block to be quite small and easy to understand.

The `#paginate_articles` method will have to do three things: fetch a list of all articles to paginate, split the entire list of articles in a list of sub-lists (read: “pages”), and finally generate a `Nanoc::Item` for each of these sub-lists.

The first step, getting all articles to paginate, is quite easy. It will probably look a bit like this:

<pre title="Fetching all articles to paginate"><code class="language-ruby">articles_to_paginate = items.select { |i| i[:kind] == 'article' }.
  sort_by { |a| Time.parse(a[:created_at]) }</code></pre>

However, you can use the blogging helper to make this a bit cleaner. The blogging helper has a [`#sorted_articles`](http://nanoc.ws/docs/api/Nanoc/Helpers/Blogging.html#sorted_articles-instance_method) method, which does exactly that: it takes all items with `kind` equal to `'article'` and sorts them on their `created_at` attribute. Here’s the cleaned-up version:

<pre title="Fetching all articles to paginate (alternative approach)"><code class="language-ruby">articles_to_paginate = sorted_articles</code></pre>

The helper still needs to be activated for this to work, like this:

<pre title="Enabling the Blogging helper"><code class="language-ruby">include Nanoc::Helpers::Blogging</code></pre>

The next step involves splitting the list of articles into sub-arrays. Here’s an easy way to do it:

<pre title="Splitting the list of articles into sub-lists"><code class="language-ruby">article_groups = []
until articles_to_paginate.empty?
  article_groups &lt;&lt; articles_to_paginate.slice!(0..4)
end</code></pre>

This will generate sub-lists of length 5, but you can make the length of these pages configurable by adding `page_size: 5` in the site configuration and changing the article-slicing code to the following:

<pre title="Splitting the list of articles into sub-lists (configurable approach)"><code class="language-ruby">article_groups = []
until articles_to_paginate.empty?
  article_groups &lt;&lt; articles_to_paginate.slice!(0..@config[:page_size]-1)
end</code></pre>

The final step involves generating pages for each individual sub-list. This is done by constructing `Nanoc::Item` objects and adding them to the `@items` array, like this:

<pre title="Generating items for each of the sub-lists"><code class="language-ruby">article_groups.each_with_index do |subarticles, i|
  first = i*config[:page_size] + 1
  last  = (i+1)*config[:page_size]

  @items &lt;&lt; Nanoc::Item.new(
    "… page content here …",
    { :title => "Archive (articles #{first} to #{last})" },
    "/blog/archive/#{i+1}/"
  )
end</code></pre>

In this piece of code, I’m running over each sub-list (named articles) with the index of the sub-list (named i). I’m also calculating the index of the first and the last article, so I can give the pagination pages titles such as “Archive (articles 15 to 20).” The last statement generates the actual item: the first argument is the page content (see next paragraph), the second argument is a hash with attributes, and the last argument is the item identifier.

Obviously, one thing that is still lacking from the above piece of code is the content for the pagination page. This content should be code that runs over each article and prints each one. The content for this pagination page is rather large, so I’ve opted to create a partial named `pagination_page` and put the content in there. This partial is stored in layouts/pagination_page.erb and looks like this:

<pre title="The content for the pagination_page partial"><code class="language-html">&lt;% pages = sorted_articles.slice(@item_id*@config[:page_size], @config[:page_size]) %&gt;
&lt;% pages.each do |article| %>
  &lt;h1>&lt;%= article[:title] %>&lt;/h1>
  &lt;%= article.compiled_content %>
&lt;% end %></code></pre>

Your version should probably be a little more fancy, including a navigation bar and previous/next links, but you get the idea: this piece of code takes a sub-list of the list of all articles and iterates over this sub-list. To make the newly generated pagination pages render this partial, replace the “page content here” string with the following:

<pre title="The content for the paginated pages"><code class="language-ruby">"&lt;%= render 'pagination_page', :item_id => #{i} %>"</code></pre>

The final thing that you should take care of, is to ensure that the pagination_page partial is rendered using the correct filter. In the Rules file, add this line above all other layout rules:

<pre title="The layout rule for the pagination_page partial"><code class="language-ruby">layout '/pagination_page/', :erb</code></pre>

You should also ensure that the generated pagination pages are filtered using erb. Add this line above all other compilation rules:

<pre title="The compilation rule for the on-the-fly generated pagination pages"><code class="language-ruby">compile '/blog/archive/*/' do
  filter :erb
  layout '/default/'
end</code></pre>

When you compile the site now, you should see that nanoc generates new files corresponding to the pagination pages, such as output/blog/archive/1/index.html. Mission complete!
