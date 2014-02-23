---
title:    "Creating multilingual sites"
---

Multilingual sites
------------------

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

Implementation
--------------

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

Redirects
---------

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

… or you can set the `base_url` confguration attribute in `nanoc.yaml` (or `config.yaml` for older sites) and generate the PHP code for setting it (a bit icky, but DRYer):

<pre title="Setting the base URL (DRYer version)"><code class="language-php">
$base_url = &#x27;&lt;%= @site.config[:base_url] %&gt;&#x27;;
</code></pre>

That’s the end of this guide. Now, you have a web site in multiple languages where every language is given equal attention. For example, a German speaking person can arrive on the site and be redirected to the German version of the site, and even the URLs will be in German.
