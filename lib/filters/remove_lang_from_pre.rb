# frozen_string_literal: true

Class.new(Nanoc::Filter) do
  identifier :remove_lang_from_pre

  def run(content, _params = {})
    content.lines.grep_v(/^\s+#!/).join
  end
end
