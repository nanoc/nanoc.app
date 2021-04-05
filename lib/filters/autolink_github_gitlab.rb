# frozen_string_literal: true

Class.new(Nanoc::Filter) do
  identifier :autolink_github_gitlab

  def run(content, _params = {})
    content
      .gsub(/#(\d+)/) { |m| %(<a href="https://github.com/nanoc/nanoc/issues/#{m[1..-1]}">#{m}</a>) }
      .gsub(/!(\d+)/) { |m| %(<a href="https://gitlab.com/nanoc/nanoc/-/merge_requests/#{m[1..-1]}">#{m}</a>) }
  end
end
