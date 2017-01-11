Class.new(Nanoc::DataSource) do
  identifier :release_notes

  CONTENT_PREFIX = "See the [release notes](/release-notes/) page for a summary of new features.\n\n"

  def items
    return [] unless defined?(Bundler)

    # content
    path = Bundler.rubygems.find_name('nanoc').first.full_gem_path
    raw_content = File.read("#{path}/NEWS.md")
    content = CONTENT_PREFIX + raw_content.sub(/^#.*$/, '') # remove h1

    # attributes
    attributes = {
      title: 'Detailed release notes',
      markdown: 'basic',
      extension: 'md'
    }

    # identifier
    identifier = Nanoc::Identifier.new('/release-notes/details.md')

    item = new_item(content, attributes, identifier)

    [ item ]
  end
end
