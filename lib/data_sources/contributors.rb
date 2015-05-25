# encoding: utf-8

module NanocSite

  class ContributorsDataSource < Nanoc::DataSource

    identifier :contributors

    def items
      path = Bundler.rubygems.find_name('nanoc').first.full_gem_path
      raw_content = File.read(File.join(path, 'README.md'))
      content = raw_content.lines.to_a.last

      item = new_item(
        content,
        { is_partial: true },
        Nanoc::Identifier.new('/contributing/contributors', style: :full)
      )

      [ item ]
    end

  end

end
