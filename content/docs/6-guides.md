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

To use the deploy:rsync task, open the config.yaml file and add a `deploy` hash. Inside, add a `default` hash, which will correspond to the default configuration to use when invoking the rake task without extra arguments. Inside the default hash, set `dst` to the destination, in the format used by rsync and scp, to where the files should be uploaded. Here’s what it will look like:

<pre title="A simple deployment configuration"><code class="language-yaml">deploy:
  default:
    dst: "stoneship.org:/var/www/sites/example.com"</code></pre>

By default, the rake task will upload all files in the output directory to the given location. None of the existing files in the target location will be deleted; however, be aware that files with the same name will be overwritten. You can run the deployment task like this:

<pre title="Deploying"><span class="prompt">%</span> <kbd>rake deploy:rsync</kbd></pre>

If you want to check whether the executed `rsync` command is really correct, you can perform a dry run by setting the `dry_run` variable (doesn’t matter to what, as long as it’s not empty). The rsync command will be printed, but not executed. For example:

<pre title="Performing a dry run"><span class="prompt">%</span> <kbd>rake deploy:rsync dry_run=true</kbd></pre>

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

Paginating articles
-------------------

First, a word of caution: I am not a fan of paginating items. Even though pagination is fairly easy to do in nanoc, I recommend not doing it, for one specific reason. Every time an object is added to a paginated collection, one object shifts from one page to the next. When a paginated page is bookmarked, it may show entirely different content a month later, and when a paginated page turns up as a result on a search engine, it may no longer contain the content that the person was looking for anymore. To avoid these issues, I recommend creating separate pages for each category, tag or year. Having said all this, I’ll nonetheless show you how to do pagination in nanoc, so you can get an idea of how it can be done.

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

Using binary items effectively
------------------------------

nanoc 3.1 adds support for binary items. Such items will not be loaded into memory, allowing nanoc to handle large files if necessary. Images, audio files and videos are good examples of binary items. Support for binary items makes nanoc quite powerful. This section gives a couple of examples of how binary items can be used.

### Building an image gallery

If you want to include a gallery on your web site, containing thumbnails that link to full-size images, you can let nanoc handle the thumbnail generation instead of generating the thumbnails up front.

<p class="warning"><strong>Note:</strong> If you have a lot of images to convert, and if the conversion process itself is taking a long time, consider performing the conversion up-front once, and then let a Rake task copy the generated thumbnails into the output directory. nanoc’s dependency resolution is not yet perfect; nanoc may decide to recompile items even though they do not need to.</p>

This example assumes that several images are stored in the `content/gallery` folder. A file at `content/gallery.html` corresponds to the gallery page itself; this item is filtered through ERB and, for the time being, contains a list of links to full-size images:

<pre title="Original code for the gallery page"><code class="language-rhtml">
&lt;ul>
&lt;% @item.children.each do |img| %>
  &lt;li>&lt;a href="&lt;%= img.path %>">&lt;%= img.path %>&lt;/a>&lt;/li>
&lt;% end %>
&lt;/ul>
</code></pre>

This gallery page will be enhanced so that it displays a list of thumbnails of these images, rather than the paths to the images.

In order to let the site handle full-size images, there will need to be a compilation rule and a routing rule for full-size images. The compilation rule does not need to do anything; the image should simply be copied. Here’s what the rules look like:

<pre title="Compilation and routing rules for the full-size representations"><code class="language-ruby">
compile '/gallery/*/' do
end

route '/gallery/*/' do
  # Make sure that /gallery/some_image/ is routed to
  # /gallery/some_image.jpg or /gallery/some_image.png or so
  item.identifier.chop + '.' + item[:extension]
end
</code></pre>

To generate the image thumbnails, a custom filter will be necessary. Depending on what OS you are on, and what software you have installed, you may need to use different filters. On Mac OS X, you can use `sips`, so place this in `lib/filters/thumbnailize.rb`:

<pre title="Filter for generating thumbnails using sips"><code class="language-ruby">
class Thumbnailize &lt; Nanoc3::Filter

  identifier :thumbnailize
  type       :binary

  def run(filename, params={})
    system(
      'sips',
      '--resampleWidth',
      params[:width].to_s,
      '--out',
      output_filename,
      filename
    )
  end

end
</code></pre>

On platforms that have `convert`, which is part of [ImageMagick](http://www.imagemagick.org/) and [GraphicsMagick](http://www.graphicsmagick.org/), you can use the following filter instead:

<pre title="Filter for generating thumbnails using convert"><code class="language-ruby">
class Thumbnailize &lt; Nanoc3::Filter

  identifier :thumbnailize
  type       :binary

  def run(filename, params={})
    system(
      'convert',
      '-resize',
      params[:width].to_s,
      filename,
      output_filename
    )
  end

end
</code></pre>

To generate the actual thumbnails, the images will need a `:thumbnail` representation, and accompanying compilation/routing rules:

<pre title="Compilation and routing rules for the thumbnail representations"><code class="language-ruby">
compile '/gallery/*/', :rep => :thumbnail do
  filter :thumbnailize, :width => 200
end

route '/gallery/*/', :rep => :thumbnail do
  item.identifier.chop + '-thumbnail.' + item[:extension]
end
</code></pre>

When the site is compiled now, you’ll find both `output/gallery/some_image.jpg` as well as `output/gallery/some_image-thumbnail.jpg`, corresponding to the full-size image and its thumbnail. The gallery page can now be updated so that it displays these images:

<pre title="Updated code for the gallery page"><code class="language-rhtml">
&lt;ul>
&lt;% @item.children.each do |img| %>
  &lt;li>
    &lt;a href="&lt;%= img.path %>">
      &lt;img src="&lt;%= img.path(:rep => :thumbnail) %>">
    &lt;/a>
  &lt;/li>
&lt;% end %>
&lt;/ul>
</code></pre>

If you want to give each thumbnail a bit of ALT text, you can do so by treating the ALT text as metadata that you want to assign to that item. To do so, create a metadata file for the item you want to give the ALT text; this file will have the same name as the image file itself, but a different extension (“.yaml”). For example, an image at `content/gallery/rick.jpg` would have a metadata file named `content/gallery/rick.yaml`. Inside the newly created YAML file, add the ALT text, like this:

<pre title="Metadata for an item"><code class="language-yaml">
alt: "A picture of a kitten that looks cute but is actually quite evil"
</code></pre>

Writing the ALT text on the gallery page is now as simple as printing the `img[:alt]` text, like this:

<pre title="Updated code for the gallery page with ALT text"><code class="language-rhtml">
&lt;ul>
&lt;% @item.children.each do |img| %>
  &lt;li>
    &lt;a href="&lt;%= img.path %>">
      &lt;img src="&lt;%= img.path(:rep => :thumbnail) %>" alt="&lt;%= img[:alt] %>">
    &lt;/a>
  &lt;/li>
&lt;% end %>
&lt;/ul>
</code></pre>

The resulting page will still not be very pretty, though. You’d definitely need to arrange the thumbnails properly, perhaps using some CSS floats. Properly styling this page with CSS, however, is left as an excercise for the reader. :)

### Preparing videos for HTML5

Let’s see how a video file can be handled by nanoc. The video file that I’ll use in this example is a H.264 file, which I would like to use in a HTML5 `<video>` element. Because Firefox does not support the H.264 format, we’ll let nanoc convert this item into a Theora-encoded movie in an Ogg container.

<p class="warning"><strong>Note:</strong> Because videos can take a long time to convert (several minutes or more), and because nanoc’s dependency resolution is not yet perfect, it is for the time being not recommended to let nanoc convert these items. It may be better to convert movies up front and copy them to the output directory at compile time (perhaps using a Rake task).</p>

Let’s assume the source video file is stored in `content/movies/rick.mp4`. For the time being, let’s just copy this file to the output and not transform it yet. For this, a compilation and a routing rule will be necessary:

<pre title="Compilation and routing rules for the default representation"><code class="language-ruby">
compile '/movies/*/' do
  # Do nothing
end

route '/movies/*/' do
  # Make sure that "/movies/rick/" becomes "/movies/rick.mp4"
  item.identifier.chop + '.' + item[:extension]
end
</code></pre>

We’ll use the <a href="http://v2v.cc/~j/ffmpeg2theora/">ffmpeg2theora</a> commandline tool to convert videos from various source formats into Theora. Usually, `ffmpeg2theora` will be invoked like this:

<pre title="Using ffmpeg2theora to convert a file to Theora"><kbd>ffmpeg2theora</kbd> <var>input.mp4</var> <kbd>--output</kbd> <var>output.ogg</var></pre>

The conversion will be handled by a filter. The code for this filter is listed below. This filter should be stored somewhere in the `lib/` directory—I recommend `lib/filters/ffmpeg2theora.rb`. Note how the filter writes the generated file to the filename returned by the `#output_filename` method; this is necessary for nanoc to find the generated file.

<pre title="Filter that wraps ffmpeg2theora"><code class="language-ruby">
class Ffmpeg2TheoraFilter &lt; Nanoc3::Filter

  identifier :ffmpeg2theora
  type       :binary

  def run(filename, params={})
    system('ffmpeg2theora', filename, '--output', output_filename)
  end

end
</code></pre>

Note that it is a good idea to add error checking to the `#run` method here: if the executed command exits with a non-zero exit status, indicating failure, or if no output file is written, the filter should raise an exception. For clarity, this error-handling code has been left out.

Creating the Theora representations of the original video is now done by adding a compilation rule and a routing rule for a new `:theora` representation, like this:

<pre title="Compilation and routing rules for the Theora representation"><code class="language-ruby">
compile '/movies/*/', :rep => :theora do
  filter :ffmpeg2theora
end

route '/movies/*/', :rep => :theora do
  # Make sure that "/movies/rick/" becomes "/movies/rick.ogg"
  item.identifier.chop + '.ogg'
end
</code></pre>

When the site is compiled, you should find two new files the output directory: `output/movies/rick.mp4` and `output/movies/rick.ogg`, which you can now [use in HTML5 video](http://diveintohtml5.org/video.html)!

Creating multilingual sites
---------------------------

Creating a site in multiple languages can be tedious, but nanoc can nonetheless be useful in making the management of multilingual sites a bit easier. The approach that I will be describing in this guide is fairly opinionated. It is not necessarily the best way, but it is an approach that worked quite well for me. This guide is inspired by the techniques I used for the [Myst Online web site](http://mystonline.com/). Feel free to check out the [source for the Myst Online web site](http://projects.stoneship.org/hg/sites-moul) to see the details about how it is done.

A multilingual site is a site where each page is available in multiple languages. Each language forms some sort of sub-site. For example, the English translation could have pages “About” and “Play,” while the Dutch translation could have matching “Over” and “Speel” pages.

For the Myst Online site, I decided to organise the pages in different languages by creating a top-level directory containing the abbreviated language name (en for English, nl for Dutch, fr for French, etc). Inside the language-specific directory, each page has a path that is also translated (so no /nl/play, but rather /nl/speel). Here’s an example:

<pre title="URL structure of a multilingual site">
/en
  /about
  /play
/nl
  /over
  /speel
/fr
  /informations
  /jouez
</pre>

The way these pages are maintained is fairly standard: each page is an individual item in the content/ directory that is compiled to the output/ directory. You’d create these items just like you would in an  ordinary, monolingual site. Here’s what the content/ directory looks like:

<pre title="Directory structure of a multilingual site">
content/
  en/
    about.html
    play.html
  nl/
    over.html
    speel.html
  fr/
    informations.html
    jouez.html
</pre>

One useful function that will be necessary later on is `#language_code_of`, which returns the language code (e.g. `en` or `nl`) for a given item. This function is implemented like this:

<pre title="Getting the language code of a given item"><code class="language-ruby">
def language_code_of(item)
  # "/en/foo/" becomes "en"
  (item.identifier.match(/^\/([a-z]{2})\//) || [])[1]
 end
</code></pre>

Once you have the basic content, you can improve the site to make it easier for switch languages. For this to work, each item needs a “canonical identifier” so that it is easy to find translations of a given page. The same items in different languages will all have the same canonical identifier. For the Myst Online web site, I chose the English identifier as the canonical identifier, but the choice you make here is fairly arbitrary. For example, the “/en/about/” page has “/about/” as its canonical identifier, and “/nl/speel/” has “/play/” as its canonical identifier. The canonical identifier is probably best stored in a `canonical_identifier` attribute.

Now, it is possible to find all translations of a given item simply by finding all items with the same canonical identifier. This is fairly simple:

<pre title="Finding all translations of a given item"><code class="language-ruby">
def translations_of(item)
  @items.select do |i| 
    i[:canonical_identifier] == item[:canonical_identifier]
  end
end
</code></pre>

One more function is necessary: one that converts a language code into the language name (in the language itself, so it should not return “Dutch” for “nl” but it should return “Nederlands”). Here’s now this function works:

<pre title="Finding the language name for a given language code"><code class="language-ruby">
LANGUAGE_CODE_TO_NAME_MAPPING = {
  'en' => 'English',
  'nl' => 'Nederlands'
}

def language_name_for_code(code)
  LANGUAGE_CODE_TO_NAME_MAPPING[code]
end
</code></pre>

For completeness, let’s write a function that returns the language name for a given item as well:

<pre title="Finding the language name of a given item"><code class="language-ruby">
def language_name_of(item)
  language_name_for_code(
    language_code_of(item))
end
</code></pre>

Now, it is possible to link to all translations from a given item. Here’s how it is done (in ERB):

<pre title="Listing all translations of a given item"><code class="language-rhtml">
&lt;ul&gt;
  &lt;% translations_of(@item).each do |t| %&gt;
    &lt;li&gt;
      &lt;a href=&quot;&lt;%= t.path %&gt;&quot;&gt;
        &lt;%= language_name_of(t) %&gt;
      &lt;/a&gt;
    &lt;/li&gt;
  &lt;% end %&gt;
&lt;/ul&gt;
</code></pre>

It is best to prevent linking to the active page, so you should check whether the translation `t` is the same as `@item` and handle this situation differently. For example:

<pre title="Listing all translations of a given item, improved implementation"><code class="language-rhtml">
&lt;ul&gt;
  &lt;% translations_of(@item).each do |t| %&gt;
    &lt;li&gt;
      &lt;% if @item == t %&gt;
        &lt;span class=&quot;active&quot;&gt;
          &lt;%= language_name_of(t) %&gt;
        &lt;/span&gt;
      &lt;% else %&gt;
        &lt;a href=&quot;&lt;%= t.path %&gt;&quot;&gt;
          &lt;%= language_name_of(t) %&gt;
        &lt;/a&gt;
      &lt;% end %&gt;
    &lt;/li&gt;
  &lt;% end %&gt;
&lt;/ul&gt;
</code></pre>

One extra enhancement would be to indicate the language of the link destinations as well as the language of the link text itself. For this, the `hreflang` resp. the `lang` attributes are used. Here’s what the code could look like:

<pre title="Listing all translations of a given item, improved implementation bis"><code class="language-rhtml">
&lt;ul>
  &lt;% translations_of(@item).each do |t| %>
    &lt;li>
      &lt;% if @item == t %>
        &lt;span class="active" lang="&lt;%= language_code_of(t) %>">
          &lt;%= language_name_of(t) %>
        &lt;/span>
      &lt;% else %>
        &lt;a href="&lt;%= t.path %>"
           lang="&lt;%= language_code_of(t) %>"
           hreflang="&lt;%= language_code_of(t) %>">
          &lt;%= language_name_of(t) %>
        &lt;/a>
      &lt;% end %>
    &lt;/li>
  &lt;% end %>
&lt;/ul>
</code></pre>

The language of the links and the link destinations are now indicated, but the language of the document itself isn’t yet. The `html` element should get a `lang` attribute that contains the language code. Here’s what it could look like in the layout:

<pre title="Setting the document’s language code"><code class="language-rhtml">
&lt;html lang="&lt;%= language_code_of(@item) %>">
</code></pre>

At this point, the site is already a lot friendlier for people from different languages. One thing is still missing , though: a landing page that redirects people to the language of their choice. This means that the landing page will require server-side scripting. For the Myst Online site, I used PHP as this is a widely available scripting language for creating web sites, but other languages such as Ruby would have worked as well. A good way of redirecting visitors is to check the contents of the `Accept-Language` HTTP header, find the preferred language, and then redirect them to the appropriate page.

Here’s the PHP code for parsing the header and returning a list of language codes requested by the user agent, sorted by decreasing preference (“qval”):

<pre title="Parsing the Accept-Language header"><code class="language-php">
// Parse the Accept-Language header
$langs = array();
if(isset($_SERVER['HTTP_ACCEPT_LANGUAGE']))
{
  // Parse language
  // e.g. en-ca,en;q=0.8,en-us;q=0.6,de-de;q=0.4,de;q=0.2
  preg_match_all(
    '/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i',
    $_SERVER['HTTP_ACCEPT_LANGUAGE'],
    $lang);

  if(count($lang[1]) > 0)
  {
    // Create key-value pair
    $langs = array_combine($lang[1], $lang[4]);

    // Use default q value of 1
    foreach ($langs as $lang => $val)
    {
      if ($val === '')
        $langs[$lang] = 1;
    }

    // Sort based on q value
    arsort($langs, SORT_NUMERIC);
  }
}
</code></pre>

Once the list of requested language codes is constructed, we can iterate over this list and try to redirect. For each of the requested languages, check whether the site has a translation in this language, and if it does, redirect.

First, though, we need to build the list of codes of all languages the site is translated in. This involves generating PHP code using Ruby code, which is icky, but it does the trick. Here’s the code:

<pre title="Building a PHP list of all language codes"><code class="language-rhtml">
&lt;%# Find all language codes %&gt;
&lt;%
home         = @items.find { |i| i.identifier == &#x27;/en/&#x27; }
translations = translations_of(home)
codes        = translations.map { |t| language_code_of(t) }
%&gt;

&lt;%# Build PHP array of language codes %&gt;
$codes = array(&lt;%= codes.join(&#x27;, &#x27;) %&gt;);
</code></pre>

The redirection code itself is given below. Note the redirection to the English version of the site s a fallback if no other languages could be satisfied.

<pre title="Finding the correct language to redirect to"><code class="language-php">
// Show correct site
foreach($langs as $request_lang => $qval)
{
  foreach($codes as $code)
  {
    if(strpos($request_lang, $code) === 0)
      redirect($code);
  }
}
redirect('en');
</code></pre>

The PHP `redirect()` function still needs to be implemented. This function creates a HTTP redirect to the home page in the given language. The HTTP header is different based on whether HTTP 1.0 or 1.1 is used. Here is its implementation:

<pre title="The redirect function"><code class="language-php">
function redirect($lang)
{
  global $base_url;
  
  // Set HTTP status code
  if ($_SERVER['SERVER_PROTOCOL'] == 'HTTP/1.1')
    header('HTTP/1.1 303 See Other');
  else
    header('HTTP/1.0 302 Moved Temporarily');
  
  // Set location
  header('Location: ' . $base_url . '/' . $lang . '/');
  
  // Stop!
  exit();
}
</code></pre>

The global `$base_url` variable contains the base URL for the web site. For the Myst Online web site, this is “http://mystonline.com”. It is used to build the full redirection URL. You can either hardcode this in PHP, like this:

<pre title="Setting the base URL"><code class="language-php">
$base_url = 'http://mystonline.com';
</code></pre>

… or you can set the `base_url` confguration attribute in “config.yaml” and generate the PHP code for setting it (a bit icky, but DRYer):

<pre title="Setting the base URL (DRYer version)"><code class="language-php">
$base_url = &#x27;&lt;%= @site.config[:base_url] %&gt;&#x27;;
</code></pre>

That’s the end of this guide. Now, you have a web site in multiple languages where every language is given equal attention. For example, a German speaking person can arrive on the site and be redirected to the German version of the site, and even the URLs will be in German.
