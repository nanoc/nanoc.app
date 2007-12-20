require 'hpricot'

def toc_for(page)
  # Parse with Hpricot
  doc = Hpricot(page.content)

  # Find all top-level sections
  sections = doc.search('#content > .section').map do |section|
    # Get title and ID of section
    header = section.search('> h3 span').first
    id    = section['id']
    title = header.inner_html

    # Find all sub-sections for this section
    sub_sections = section.search('> .section').map do |sub_section|
      # Get title and ID of sub-section
      sub_header = sub_section.search('> h4 span').first
      sub_id    = sub_section['id']
      sub_title = sub_header.inner_html

      { :title => sub_title, :id => sub_id }
    end

    { :title => title, :id => id, :sub_sections => sub_sections}
  end

  # Build table of contents
  res = '<ol>'
  sections.each do |section|
    # Link
    res << '<li>'
    res << '<a href="' + page.path + '#' + section[:id] + '">' + section[:title] + '</a>'
    unless section[:sub_sections].empty?
      res << '<ol>'
      section[:sub_sections].each do |sub_section|
        res << '<li>'
        res << '<a href="' + page.path + '#' + sub_section[:id] + '">' + sub_section[:title] + '</a>'
        res << '</li>'
      end
      res << '</ol>'
    end
    res << '</li>'
  end
  res << '</ol>'

  res
end
