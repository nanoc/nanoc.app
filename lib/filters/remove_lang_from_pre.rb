Class.new(Nanoc::Filter) do
  identifier :remove_lang_from_pre

  def run(content, params = {})
    content.lines.reject { |l| l =~ /^\s+#!/ }.join
  end
end
