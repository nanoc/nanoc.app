require 'htmlcompressor'

Class.new(Nanoc::Filter) do
  identifier :htmlcompressor

  def run(content, params = {})
    compressor = HtmlCompressor::Compressor.new
    compressor.compress(content)
  end
end
