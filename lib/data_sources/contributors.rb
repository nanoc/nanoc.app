# encoding: utf-8

module NanocSite

  class ContributorsDataSource < Nanoc::DataSource

    identifier :contributors

    def items
      spec = Gem::Specification.find_by_name("nanoc")
      raw_content = File.read(File.join(spec.gem_dir, 'README.md'))
      content = raw_content.lines.to_a.last

      item = Nanoc::Item.new(
        content,
        { is_partial: true },
        '/contributing/contributors/'
      )

      [ item ]
    end

  end

end
