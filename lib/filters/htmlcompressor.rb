require 'htmlcompressor'

Class.new(Nanoc::Filter) do
  identifier :htmlcompressor

  def run(content, params = {})
    compressor = HtmlCompressor::Compressor.new(
      enabled: true,
      remove_multi_spaces: true,
      remove_comments: true,
      remove_intertag_spaces: true,
      remove_quotes: true,
      compress_css: false,
      compress_javascript: false,
      simple_doctype: true,
      remove_script_attributes: false,
      remove_style_attributes: false,
      remove_link_attributes: false,
      remove_form_attributes: false,
      remove_input_attributes: false,
      remove_javascript_protocol: false,
      remove_http_protocol: false,
      remove_https_protocol: false,
      preserve_line_breaks: false,
      simple_boolean_attributes: false,
      compress_js_templates: false
    )
    compressor.compress(content)
  end
end
