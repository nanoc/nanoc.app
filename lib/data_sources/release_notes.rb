# encoding: utf-8

module NanocSite

  class ReleaseNotesDataSource < Nanoc::DataSource

    identifier :release_notes

    def items
      # content
      spec = Gem::Specification.find_by_name("nanoc-core")
      raw_content = File.read(File.join(spec.gem_dir, 'NEWS.md'))
      content = raw_content.sub(/^#.*$/, '') # remove h1

      # attributes
      attributes = {
        title: 'Release Notes',
        markdown: 'basic',
        extension: 'md',
      }

      item = Nanoc::Item.new(content, attributes, '/release-notes.md')

      [ item ]
    end

  end

end
