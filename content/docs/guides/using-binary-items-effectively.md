---
title:    "Using binary items effectively"
---

What are binary items?
----------------------

nanoc 3.1 adds support for binary items. Such items will not be loaded into memory, allowing nanoc to handle large files if necessary. Images, audio files and videos are good examples of binary items. Support for binary items makes nanoc quite powerful. This section gives a couple of examples of how binary items can be used.

Building an image gallery
-------------------------

If you want to include a gallery on your web site, containing thumbnails that link to full-size images, you can let nanoc handle the thumbnail generation instead of generating the thumbnails up front.

NOTE: If you have a lot of images to convert, and if the conversion process itself is taking a long time, consider performing the conversion up-front once, and then let a Rake task copy the generated thumbnails into the output directory. nanoc’s dependency resolution is not yet perfect; nanoc may decide to recompile items even though they do not need to.

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
class Thumbnailize &lt; Nanoc::Filter

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
class Thumbnailize &lt; Nanoc::Filter

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

Preparing videos for HTML5
--------------------------

Let’s see how a video file can be handled by nanoc. The video file that I’ll use in this example is a H.264 file, which I would like to use in a HTML5 `<video>` element. Because Firefox does not support the H.264 format, we’ll let nanoc convert this item into a Theora-encoded movie in an Ogg container.

NOTE: Because videos can take a long time to convert (several minutes or more), and because nanoc’s dependency resolution is not yet perfect, it is for the time being not recommended to let nanoc convert these items. It may be better to convert movies up front and copy them to the output directory at compile time (perhaps using a Rake task).

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

We’ll use the <a href="http://v2v.cc/~j/ffmpeg2theora/">ffmpeg2theora</a> command-line tool to convert videos from various source formats into Theora. Usually, `ffmpeg2theora` will be invoked like this:

<pre title="Using ffmpeg2theora to convert a file to Theora"><kbd>ffmpeg2theora</kbd> <var>input.mp4</var> <kbd>--output</kbd> <var>output.ogg</var></pre>

The conversion will be handled by a filter. The code for this filter is listed below. This filter should be stored somewhere in the `lib/` directory—I recommend `lib/filters/ffmpeg2theora.rb`. Note how the filter writes the generated file to the filename returned by the `#output_filename` method; this is necessary for nanoc to find the generated file.

<pre title="Filter that wraps ffmpeg2theora"><code class="language-ruby">
class Ffmpeg2TheoraFilter &lt; Nanoc::Filter

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

When the site is compiled, you should find two new files the output directory: `output/movies/rick.mp4` and `output/movies/rick.ogg`, which you can now [use in HTML5 video](http://diveintohtml5.info/video.html)!
