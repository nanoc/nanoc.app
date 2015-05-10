module NanocSite

  module ReleaseNotes

    TITLE_REGEX = /^(\d+\.\d+(\.\d+){0,2}) \((\d{4}-\d{2}-\d{2})\)$/

    # Returns a hash with `:version`, containing the latest released version,
    # and `:date`, containing the latest released version’s release date.
    def latest_release_info
      require 'nokogiri'

      # Get release notes page
      content = @items['/release-notes'].compiled_content
      doc = Nokogiri::HTML(content)

      # Find and parse usable h2
      h2 = doc.css('h2').find { |h2| h2.inner_html.strip =~ TITLE_REGEX }
      h2 =~ TITLE_REGEX

      # Done
      { :version => $1, :date => Date.parse($3) }
    end

  end

end
