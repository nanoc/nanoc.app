---
title: "Using binary items effectively"
---

Along with textual items, Nanoc also supports binary items. Binary items are not loaded into memory, enabling Nanoc to handle large files. Examples of binary items include images, fonts, audio files, and videos.

This page gives an example of how binary items can be used.

Building an image gallery
-------------------------

If you want to include a gallery on your web site, containing thumbnails that link to full-size images, you can let Nanoc handle the thumbnail generation instead of generating the thumbnails up front.

NOTE: If you have a lot of images to convert, and if the conversion process itself is taking a long time, consider performing the conversion up-front once, and then let a Rake task copy the generated thumbnails into the output directory. Nanoc’s dependency resolution is not yet perfect; Nanoc may decide to recompile items even though they do not need to.

This example assumes that several images are stored in the <span class="filename">content/gallery</span> folder. A file at <span class="filename">content/gallery.html</span> corresponds to the gallery page itself; this item is filtered through ERB and, for the time being, contains a list of links to full-size images:

    #!rhtml
    <ul>
    <% @items.find_all('/gallery/*').each do |img| %>
      <li><a href="<%= img.path %>"><%= img.path %></a></li>
    <% end %>
    </ul>

Ensure that the gallery page is filtered using ERB. For example:

    #!ruby
    compile '/gallery.*'
      filter :erb
    end

The images themselves will be copied as-is. To do so, add the following to the <span class="filename">Rules</span> file, at the top:

    #!ruby
    passthrough '/gallery/*'

At this point, the image gallery is functioning, but does not yet include thumbnails

### Generating thumbnails

This gallery page will be enhanced so that it displays a list of thumbnails of these images, rather than the paths to the images.

To generate the image thumbnails, a custom filter will be necessary. Depending on what OS you are on, and what software you have installed, you may need to use different filters. On Mac OS X, you can use <span class="command">sips</span>, so place this in <span class="filename">lib/filters/thumbnailize.rb</span>:

    #!ruby
    class Thumbnailize < Nanoc::Filter
      identifier :thumbnailize
      type       :binary

      def run(filename, params = {})
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

On platforms that have <span class="command">convert</span>, which is part of [ImageMagick](http://www.imagemagick.org/) and [GraphicsMagick](http://www.graphicsmagick.org/), you can use the following filter instead:

    #!ruby
    class Thumbnailize < Nanoc::Filter
      identifier :thumbnailize
      type       :binary

      def run(filename, params = {})
        system(
          'convert',
          '-resize',
          params[:width].to_s,
          filename,
          output_filename
        )
      end
    end

To generate the actual thumbnails, the images will need a `:thumbnail` representation, and accompanying compilation/routing rules:

    #!ruby
    compile '/gallery/*', rep: :thumbnail do
      filter :thumbnailize, width: 200
    end

    route '/gallery/*', rep: :thumbnail do
      item.identifier.without_ext + '-thumbnail.' + item.ext
    end

When the site is compiled now, you’ll find both <span class="filename">output/gallery/some_image.jpg</span> as well as <span class="filename">output/gallery/some_image-thumbnail.jpg</span>, corresponding to the full-size image and its thumbnail. The gallery page can now be updated so that it displays the thumbnails:

    #!rhtml
    <ul>
    <% @items.find_all('/gallery/*').each do |img| %>
      <li>
        <a href="<%= img.path %>">
          <img src="<%= img.path(rep: :thumbnail) %>">
        </a>
      </li>
    <% end %>
    </ul>

If you want to give each thumbnail a bit of `ALT` text, you can do so by treating the `ALT` text as metadata that you want to assign to that item. To do so, create a metadata file for the item you want to give the `ALT` text; this file will have the same name as the image file itself, but a different extension (“.yaml”). For example, an image at <span class="filename">content/gallery/rick.jpg</span> would have a metadata file named <span class="filename">content/gallery/rick.yaml</span>. Inside the newly created YAML file, add the `ALT` text, like this:

    #!yaml
    alt: "A picture of a kitten that looks cute but is actually quite evil"

Writing the ALT text on the gallery page is now as simple as printing the `img[:alt]` text, like this:

    #!rhtml
    <ul>
    <% @items.find_all('/gallery/*').each do |img| %>
      <li>
        <a href="<%= img.path %>">
          <img src="<%= img.path(rep: thumbnail) %>" alt="<%= img[:alt] %>">
        </a>
      </li>
    <% end %>
    </ul>

And done! All that’s left at this point is styling the page.
