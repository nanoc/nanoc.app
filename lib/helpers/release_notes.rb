module NanocSite

  module ReleaseNotes

    # Returns a hash with `:version`, containing the latest released version,
    # and `:date`, containing the latest released version’s release date.
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
