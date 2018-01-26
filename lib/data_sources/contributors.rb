# frozen_string_literal: true

Class.new(Nanoc::DataSource) do
  identifier :contributors

  def items
    readme = Net::HTTP.get(URI.parse('https://raw.githubusercontent.com/nanoc/nanoc/master/README.md'))
    content = readme.lines.to_a.last.force_encoding('UTF-8')

    item = new_item(
      content.encode('UTF-8'),
      {},
      Nanoc::Identifier.new('/contributing/_contributors'),
    )

    [item]
  end
end
