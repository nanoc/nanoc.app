---

title:                 "Guides"
toc_includes_sections: true
markdown:              basic

---

Deploying sites
---------------

There are quite a few ways to deploy a site to a web host. The most traditional way of uploading a site involves using FTP to transfer the files (perhaps using an “update” or “synchronise” option). If your web host provides access via SSH, you can use SCP or SFTP to deploy a site.

### With rsync

If your web host supports rsync, then deploying a site can be fully automated, and the transfer itself can be quite fast, too. rsync is unfortunately a bit cumbersome, providing a great deal of options (check <kbd>man rsync</kbd> in case of doubt), but fortunately nanoc provides a “deploy:rsync” rake task that can make this quite a bit easier: a simple <kbd>rake deploy:rsync</kbd> will deploy your site.

To use the deploy:rsyn task, open the config.yaml file and add a `deploy` hash. Inside, add a `default` hash, which will correspond to the default configuration to use when invoking the rake task without extra arguments. Inside the default hash, set `dst` to the destination, in the format used by rsync and scp, to where the files should be uploaded. Here’s what it will look like:

<pre title="A simple deployment configuration"><code class="language-yaml">deploy:
  default:
    dst: "stoneship.org:/var/www/sites/example.com"</code></pre>

By default, the rake task will upload all files in the output directory to the given location. None of the existing files in the target location will be deleted; however, be aware that files with the same name will be overwritten. You can run the deployment task like this:

<pre title="Deploying"><span class="prompt">%</span> <kbd>rake deploy:rsync</kbd></pre>

You can override the options that nanoc uses for invoking rsync in the deploy:rsync task. The following example will make sure that all existing files on the remote server are deleted after uploading (warning! use with caution!).

<pre title="Custom rsync options in the deployment configuration"><code class="language-yaml">options: [ '-gpPrtvz', '--delete-after' ]</code></pre>

As you have seen, the `deploy` hash in the site configuration file can have multiple sub-hashes for different deployment configurations. For example, I could have “public” and “staging” configurations that deploy the site to different locations. Here’s what the corresponding configuration file would look like in that case:

<pre title="Multiple deployment configurations in config.yaml"><code class="language-yaml">deploy:
  public:
    dst: "stoneship.org:/var/www/sites/example.com"
  staging:
    dst: "stoneship.org:/var/www/sites/staging.example.com"</code></pre>

Now, the deploy:rsync task can be invoked using a `config` argument that corresponds to the deployment configuration that you want to use. For example, to deploy using the staging configuration, I’d invoke the task like this:

<pre title="Deploying with a custom configuration"><span class="prompt">%</span> <kbd>rake deploy:rsync config=staging</kbd></pre>

### With a VCS (git, hg, …)

<p class="fixme">Write me (someone else needs to write this because I’m not quite experienced enough with git post-push or post-commit hooks.)</p>

### Deploying to a sub-site

<p class="fixme">Write me</p>

Using Compass
-------------

<p class="fixme">Write me</p>

Paginating articles
-------------------

First, a word of caution: I am not a fan of paginating items. Even though pagination is fairly easy to do in nanoc, I recommend not doing it, for one specific reason. Every time an object is added to a paginated collection, one object shifts from one page to the next. When a paginated page is bookmarked, it may show entirely different content a month later, and when a paginated page turns up as a result on a search engine, it may no longer contain the content that the person was looking for anymore. To avoid these issues, I recommend creating separate pages for each category, tag or year. Having said all this, I’ll nonetheless show you how to do pagination in nanoc, so you can get an idea of how it can be done.

To paginate articles, we’ll use the preprocessor block in the Rules file. This preprocessor block will look like this:

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

The `#paginate_articles` method will have to do three things: fetch a list of all articles to paginate, split the entire list of articles in a list of sub-lists (read: “pages”), and finally generate a `Nanoc3::Item` for each of these sub-lists.

The first step, getting all articles to paginate, is quite easy. It will probaly look a bit like this:

<pre title="Fetching all articles to paginate"><code class="language-ruby">articles_to_paginate = items.select { |i| i[:kind] == 'article' }.
  sort_by { |a| Time.parse(a[:created_at]) }</code></pre>

However, you can use the blogging helper to make this a bit cleaner. The blogging helper has a #sorted_articles method, which does exactly that. Here’s the cleaned-up version:

<pre title="Fetching all articles to paginate (alternative approach)"><code class="language-ruby">include Nanoc3::Helpers::Blogging
articles_to_paginate = sorted_articles</code></pre>

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

The final step involves generating pages for each individual sub-list. This is done by constructing `Nanoc3::Item` objects and adding them to the `@items` array, like this:

<pre title="Generating items for each of the sub-lists"><code class="language-ruby">article_groups.each_with_index do |subarticles, i|
  first = i*config[:page_size] + 1
  last  = (i+1)*config[:page_size]

  @items &lt;&lt; Nanoc3::Item.new(
    "... page content here ...",
    { :title => "Archive (articles #{first} to #{last})" }
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

Creating tag/category pages
---------------------------

Creating separate pages for each tag or category is similar to paginating articles (see the section above), but is simpler. There are two approaches of handling tag/category pages: the first involves manually creating the individual tag/category pages on the disk, and the second one involves creating them in-memory at runtime; I’ll use the second approach since it is easier to use for large amounts of different tags.

<p class="fixme">Write me</p>

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
