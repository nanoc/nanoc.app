module NanocSite

  # This module (specific to the nanoc web site) contains two functions that
  # get the latest release version and the latest release notes, respectively.
  # They're used on the download page, to prevent having to duplicate the
  # latest release notes on both the release notes and the download pages.
  module ReleaseNotes

    def latest_release_info
      require 'nokogiri'

      # Get release notes page
      content = @items.find { |i| i.identifier == '/release-notes/' }.compiled_content
      doc = Nokogiri::HTML(content)

      # Parse title
      raw = doc.css('h2').first.inner_html.strip
      if raw !~ /^(\d\.\d(\.\d)?) \((\d{4}-\d{2}-\d{2})\)$/
        raise RuntimeError, "title does not match latest release info regex: #{raw.inspect}"
      end

      # Done
      { :version => $1, :date => Date.parse($3) }
    end

  end

end
