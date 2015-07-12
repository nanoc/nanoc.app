Class.new(Nanoc::DataSource) do
  identifier :contributors

  def items
    path = Bundler.rubygems.find_name('nanoc').first.full_gem_path
    raw_content = File.read(File.join(path, 'README.md'))
    content = raw_content.lines.to_a.last

    item = new_item(
      content,
      {},
      Nanoc::Identifier.new('/contributing/_contributors')
    )

    [item]
  end
end
