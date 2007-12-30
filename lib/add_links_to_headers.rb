# This filters adds permalinks to all section headers.
module Nanoc::Filter::AddLinksToHeaders
  class AddLinksToHeadersFilter < Nanoc::Filter

    identifiers :add_links_to_headers

    def run(content)
      nanoc_require 'hpricot'

      # Parse with Hpricot
      doc = Hpricot(content)

      # Find top-level sections
      doc.search('#content > .section').each do |section|
        # Find ID
        section_id = section['id']
        next if section_id.nil?

        # Add permalink to header
        section_header = section.search('> h3 > span')
        section_header.append(permalink_for(section_id))

        # Find sub-sections
        section.search('> .section').each do |subsection|
          # Find ID
          subsection_id = subsection['id']
          next if subsection_id.nil?

          # Add permalink to header
          subsection_header = subsection.search('> h4 > span')
          subsection_header.append(permalink_for(subsection_id))
        end
      end

      doc.to_s
    end

  private

    # Creates a permalink for the given section ID
    def permalink_for(section_id)
      %[ <a class="permalink" rel="bookmark" href="##{section_id}" title="Permanent link to this section">&#182;</a>]
    end

  end
end
