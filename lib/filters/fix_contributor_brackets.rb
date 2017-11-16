Class.new(Nanoc::Filter) do
  identifier :fix_contributor_brackets

  def run(content, _params = {})
    content.gsub(/ \[([^\]]+)\]\)?$/, ' \[\1\]')
  end
end
