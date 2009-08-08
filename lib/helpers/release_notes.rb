require 'hpricot'

module Nanoc3::Helpers

  # This module (specific to the nanoc web site) contains two functions that
  # get the latest release version and the latest release notes, respectively.
  # They're used on the download page, to prevent having to duplicate the
  # latest release notes on both the release notes and the download pages.
  module ReleaseNotes

    def latest_release_version
      # Get release notes page
      content = @items.find { |item| item.identifier == '/about/release-notes/' }.reps[0].content_at_snapshot(:pre)
      doc = Nokogiri::HTML(content)

      # Get the version
      doc.css('h2').first.inner_html.strip
    end

    def latest_release_notes
      # Get release notes page
      doc = Nokogiri::HTML(@items.find { |item| item.identifier == '/about/release-notes/' }.reps[0].content_at_snapshot(:pre))

      # Get latest release
      latest_release = doc.search('.section').first

      # Remove the header
      latest_release.search('h2').remove

      # Get the release notes
      latest_release.inner_html.strip
    end

  end

end
