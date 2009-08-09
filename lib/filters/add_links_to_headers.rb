module Nanoc3::Filters

  # This filters adds permalinks to all section headers.
  class AddLinksToHeaders < Nanoc3::Filter

    identifiers :add_links_to_headers

    def run(content, arguments={})
      require 'nokogiri'

      # Parse
      doc = Nokogiri::HTML(content)

      # Find top-level sections
      doc.css('.section').each do |section|
        # Find ID
        section_id = section['id']
        next if section_id.nil?

        # Add permalink to header
        section_header = section.css((1..6).map { |i| "h#{i}" }.join(', ')).first
        section_header.inner_html += permalink_for(section_id)
      end

      # Done
      doc.to_s
    end

  private

    # Creates a permalink for the given section ID
    def permalink_for(section_id)
      %[ <a class="permalink" rel="bookmark" href="##{section_id}" title="Permanent link to this section">&#182;</a>]
    end

  end

end
