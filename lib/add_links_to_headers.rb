# This filters adds permalinks to all section headers.
module Nanoc::Filter::AddLinksToHeaders
  class AddLinksToHeadersFilter < Nanoc::Filter

    identifiers :add_links_to_headers

    def run(content)
      require 'hpricot'

      # Parse with Hpricot
      doc = Hpricot(content)

      # Find top-level sections
      doc.search('.section').each do |section|
        # Find ID
        section_id = section['id']
        next if section_id.nil?

        # Add permalink to header
        section_header = section.search((1..6).map { |i| "> h#{i} > span" }.join(', '))
        section_header.append(permalink_for(section_id))
      end

      doc.to_s.gsub(' />', '>')
    end

  private

    # Creates a permalink for the given section ID
    def permalink_for(section_id)
      %[ <a class="permalink" rel="bookmark" href="##{section_id}" title="Permanent link to this section">&#182;</a>]
    end

  end
end
