Class.new(Nanoc::Filter) do
  identifier :kramdown2dmark

  def run(content, params = {})
    document = ::Kramdown::Document.new(content, params)

    document.warnings.each do |warning|
      $stderr.puts "kramdown warning: #{warning}"
    end

    document.to_nanoc_ws_dmark
  end
end
