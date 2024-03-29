# frozen_string_literal: true

require 'nokogiri'

module NanocSite
  module ReleaseNotes
    TITLE_REGEX = /^(\d+\.\d+(\.\d+){0,2}) \((\d{4}-\d{2}-\d{2})\)$/.freeze

    class Cached
      include Singleton

      def latest_release_info(compiled_content)
        @latest_release_info ||= {}
        @latest_release_info[compiled_content] ||= uncached_latest_release_info(compiled_content)
      end

      def uncached_latest_release_info(compiled_content)
        # Get release notes page
        doc = Nokogiri::HTML(compiled_content)

        # Find and parse usable h2
        h2 = doc.css('h2').find { |elem| elem.inner_html.strip =~ TITLE_REGEX }
        h2.inner_html.strip =~ TITLE_REGEX

        # Done
        { version: Regexp.last_match(1), date: Date.parse(Regexp.last_match(3)) }
      end
    end

    # Returns a hash with `:version`, containing the latest released version,
    # and `:date`, containing the latest released version’s release date.
    def latest_release_info
      compiled_content = items['/release-notes.*'].compiled_content
      Cached.instance.latest_release_info(compiled_content)
    end
  end
end
