Class.new(Nanoc::Filter) do
  identifier :kramdown2latex

  def run(content, params = {})
    params = params.merge(
      latex_headers: %w(chapter section subsection subsubsection paragraph subparagraph),
      input: @item.identifier.ext == 'erb' ? 'html' : 'kramdown',
    )

    document = ::Kramdown::Document.new(content, params)

    document.warnings.each do |warning|
      $stderr.puts "kramdown warning: #{warning}"
    end

    document.to_nanoc_ws_latex
  end
end
