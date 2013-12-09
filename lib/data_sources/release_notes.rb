# encoding: utf-8

class ReleaseNotesDataSource < Nanoc::DataSource

  identifier :release_notes

  def items
    # content
    spec = Gem::Specification.find_by_name("nanoc")
    raw_content = File.read(File.join(spec.gem_dir, 'NEWS.md'))
    content = raw_content.sub(/^#.*$/, '') # remove h1

    # attributes
    attributes = {
      title: 'Release Notes',
      markdown: 'basic',
      has_toc: true,
    }

    item = Nanoc::Item.new(content, attributes, '/release-notes/')

    [ item ]
  end

end
