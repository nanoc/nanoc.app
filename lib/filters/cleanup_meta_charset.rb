# frozen_string_literal: true

Class.new(Nanoc::Filter) do
  identifier :cleanup_meta_charset

  def run(content, _params = {})
    if content.match?(/<meta charset=[^>]+>/)
      content.sub(%r{<meta http-equiv=.?Content-Type.? content="text/html; charset=UTF-8">}, '')
    else
      content
    end
  end
end
