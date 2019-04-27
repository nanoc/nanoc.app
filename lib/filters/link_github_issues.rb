# frozen_string_literal: true

Class.new(Nanoc::Filter) do
  identifier :link_github_issues

  def run(content, _params = {})
    content.gsub(/#(\d+)/) do |m|
      num = m[1..-1]
      %(<a href="https://github.com/nanoc/nanoc/issues/#{num}">##{num}</a>)
    end
  end
end
