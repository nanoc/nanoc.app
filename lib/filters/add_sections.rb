module Nanoc3::Filters

  # This filters adds section div’s based on headers. For example, this:
  #
  # h1
  # p
  # foo
  #   p
  #   h2
  #   p
  # p
  # h2
  # p
  # p
  # h1
  # p
  #
  # is turned into
  #
  # section
  #   h1
  #   p
  #   foo
  #     p
  #     section
  #       h2
  #       p
  #     p
  #   section
  #     h2
  #     p
  #     p
  # section
  #   p
  class AddSections < Nanoc3::Filter

    identifiers :add_sections

    def run(content, arguments={})
      require 'nokogiri'

      # Parse
      doc = Nokogiri::HTML.fragment(content)

      # Add sections for all headers
      (1..6).each do |level|
        # For each header on this level
        doc.css("h#{level}").each do |header|
          # Get all siblings
          siblings = header.parent.children

          # Remove previous siblings
          siblings_after = []
          should_include = false
          siblings.each do |sibling|
            if sibling == header
              should_include = true
            elsif should_include
              siblings_after << sibling
            end
          end

          # Remove next siblings that should not be part of this section
          siblings_in_between = []
          siblings_after.each do |sibling|
            if sibling.name =~ /^h(\d)/ && $1.to_i <= level
              break
            else
              siblings_in_between << sibling
            end
          end

          # Create section
          section = Nokogiri::XML::Node.new('div', doc)
          section['class'] = 'section'
          section['id'] = header.content.downcase.gsub(/\W+/, '-').gsub(/^-|-$/, '')
          header.add_previous_sibling(section)

          # Move children into section
          header.unlink
          section.add_child(header)
          siblings_in_between.each do |sibling|
            sibling.unlink
            section.add_child(sibling)
          end
        end
      end

      # Done
      doc.to_s
    end

  end

end
