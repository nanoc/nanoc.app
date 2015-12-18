Class.new(Nanoc::Filter) do
  identifier :fix_contributor_brackets

  def run(content, params={})
    content.gsub(/ \[([^\]]+)\]\)?$/, ' \[\1\]')
  end
end
