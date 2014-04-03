# encoding: utf-8

class AdmonitionFilter < Nanoc::Filter

  identifier :admonition

  def run(content, params = {})
    content.gsub(/^(TIP|NOTE|CAUTION|TODO): (.*)$/) do |match|
      generate($1.downcase, $2)
    end
  end

  def generate(kind, content)
    s = ''
    s << %[<div class="admonition-wrapper #{kind}">]
    s << %[<div class="admonition">]
    s << content
    s << %[</div>]
    s << %[</div>]
    s
  end

end
