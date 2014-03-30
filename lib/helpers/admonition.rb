def admonition(kind, content)
  s = ''
  s << %[<div class="admonition-wrapper #{kind}">]
  s << %[<div class="admonition">]
  s << content
  s << %[</div>]
  s << %[</div>]
  s
end

class AdmonitionFilter < Nanoc::Filter

  identifier :admonition

  def run(content, params = {})
    content.gsub(/^(TIP|NOTE|CAUTION): (.*)$/) do |match|
      admonition($1.downcase, $2)
    end
  end

end
