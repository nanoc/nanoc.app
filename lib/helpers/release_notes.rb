module NanocSite

  module ReleaseNotes

    # Returns a hash with `:version`, containing the latest released version,
    # and `:date`, containing the latest released version’s release date.
    def latest_release_info
      require 'nokogiri'

      # Get release notes page
      content = @items.glob('/release-notes.*').first.compiled_content
      doc = Nokogiri::HTML(content)

      # Parse title
      raw = doc.css('h2').first.inner_html.strip
      if raw !~ /^(\d\.\d(\.\d)?) \((\d{4}-\d{2}-\d{2})\)$/
        $stderr.puts "warning: title does not match latest release info regex: #{raw.inspect}"
        return { version: '9.9.9', date: Date.parse('9999-1-1') }
      end

      # Done
      { :version => $1, :date => Date.parse($3) }
    end

  end

end
