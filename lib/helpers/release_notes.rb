module Nanoc3::Helpers

  # This module (specific to the nanoc web site) contains two functions that
  # get the latest release version and the latest release notes, respectively.
  # They're used on the download page, to prevent having to duplicate the
  # latest release notes on both the release notes and the download pages.
  module ReleaseNotes

    def latest_release_info
      require 'nokogiri'

      # Get release notes page
      content = @items.find { |item| item.identifier == '/about/release-notes/' }.reps[0].content_at_snapshot(:pre)
      doc = Nokogiri::HTML(content)

      # Parse title
      raw = doc.css('h2').first.inner_html.strip
      if raw !~ /^(\d\.\d(\.\d)?) \((\d{4}-\d{2}-\d{2})\)$/
        raise RuntimeError, "title does not match latest release info regex: #{raw.inspect}"
      end

      # Done
      { :version => $1, :date => Date.parse($3) }
    end

    def latest_release_notes
      require 'nokogiri'

      # Get release notes page
      content = @items.find { |item| item.identifier == '/about/release-notes/' }.reps[0].content_at_snapshot(:before_sections)
      doc = Nokogiri::HTML(content)

      # Get latest header
      header = doc.search('h2').first

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
        if sibling.name =~ /^h(\d)/ && $1.to_i <= 2
          break
        else
          siblings_in_between << sibling
        end
      end

      # Done
      siblings_in_between.join
    end

  end

end
