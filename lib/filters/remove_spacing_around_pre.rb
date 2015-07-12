Class.new(Nanoc::Filter) do
  identifiers :remove_spacing_around_pre

  def run(content, arguments={})
    content.gsub(/<pre( title="[^"]+")?><code( class="language-[a-z]+")?>\n/) { |m| m[0..-2] }
  end
end
