# frozen_string_literal: true

Class.new(Nanoc::DataSource) do
  identifier :release_notes

  def items
    return [] unless defined?(Bundler)

    # content
    path = Bundler.rubygems.find_name('nanoc').first.full_gem_path
    raw_content = File.read("#{path}/NEWS.md")
    content = raw_content.sub(/^#.*$/, '') # remove h1

    # attributes
    attributes = {
      title: 'Release notes',
      markdown: 'basic',
      extension: 'md',
    }

    # identifier
    identifier = Nanoc::Identifier.new('/release-notes.md')

    item = new_item(content, attributes, identifier)

    [item]
  end
end
