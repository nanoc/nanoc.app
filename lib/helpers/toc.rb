require 'hpricot'

module Nanoc3::Helpers

  # This module (specific to the nanoc site) contains functionality for
  # generating a table of contents (TOC) from a given page.
  module TOC

    def toc_for(item_rep, params={})
      require 'nokogiri'

      # Parse params
      params[:base]  ||= item_rep.path
      params[:class] ||= 'toc'

      # Parse
      doc = Nokogiri::HTML(item_rep.content_at_snapshot(:pre))

      # Find all top-level sections
      sections = doc.xpath('/html/body/div[@class="section"]').map do |section|
        # Get title and ID of section
        header = section.xpath('h2').first
        id    = section['id']
        title = header.inner_html

        # Find all sub-sections for this section
        sub_sections = section.xpath('div[@class="section"]').map do |sub_section|
          # Get title and ID of sub-section
          sub_header = sub_section.xpath('h3').first
          sub_id    = sub_section['id']
          sub_title = sub_header.inner_html

          { :title => sub_title, :id => sub_id }
        end

        { :title => title, :id => id, :sub_sections => sub_sections}
      end

      # Build table of contents
      res = params[:class] ? %[<ol class="#{params[:class]}">] : '<ol>'
      sections.each do |section|
        # Link
        res << '<li>'
        res << '<a href="' + params[:base] + '#' + section[:id] + '">' + section[:title] + '</a>'
        unless section[:sub_sections].empty?
          res << '<ol>'
          section[:sub_sections].each do |sub_section|
            res << '<li>'
            res << '<a href="' + params[:base] + '#' + sub_section[:id] + '">' + sub_section[:title] + '</a>'
            res << '</li>'
          end
          res << '</ol>'
        end
        res << '</li>'
      end
      res << '</ol>'

      res
    end

  end

end
