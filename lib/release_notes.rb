require 'hpricot'

# These two functions get the latest release version and the latest release
# notes. They're used on the download page, to prevent having to duplicate
# the latest release notes on both the release notes and the download pages.

def latest_release_version
  # Get release notes page
  doc = Hpricot(@pages.find { |page| page.path == '/download/release-notes/' }.content)

  # Get the version
  latest_release = doc.search('#content > .section.last > h3 > span').inner_html
end

def latest_release_notes
  # Get release notes page
  doc = Hpricot(@pages.find { |page| page.path == '/download/release-notes/' }.content)

  # Get latest release
  latest_release = doc.search('#content > .section.last')

  # Remove the header
  latest_release.search('> h3').remove

  # Get the release notes
  latest_release.inner_html
end
