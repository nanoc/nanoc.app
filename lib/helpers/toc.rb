module Nanoc3::Helpers

  # This module (specific to the nanoc site) contains functionality for
  # generating a table of contents (TOC) from a given page.
  module TOC

    def toc_for(item, params={})
      require 'nokogiri'

      # Parse params
      params[:base]  ||= item_rep.path
      params[:class] ||= 'toc'

      # Parse
      compiled_content = @item_rep.instance_eval { @content[:pre] }
      doc = Nokogiri::HTML(compiled_content)

      # Find all top-level sections
      sections = doc.xpath('/html/body/div[@class="section"]').map do |section|
        # Get title and ID of section
        header = section.xpath('h2').first
        id    = section['id']
        title = header.inner_html

        { :title => title, :id => id }
      end

      # Build table of contents
      res = params[:class] ? %[<ol class="#{params[:class]}">] : '<ol>'
      sections.each do |section|
        # Link
        res << '<li>'
        res << '<a href="' + params[:base] + '#' + section[:id] + '">' + section[:title] + '</a>'
        res << '</li>'
      end
      res << '</ol>'

      res
    end

  end

end
