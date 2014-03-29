def admonition(kind, content)
  s = ''
  s << %[<div class="admonition-wrapper #{kind}">]
  s << %[<div class="admonition">]
  s << content
  s << %[</div>]
  s << %[</div>]
  s
end

def note(&block)
  _erbout << admonition('note', capture(&block))
end

def caution(&block)
  _erbout << admonition('caution', capture(&block))
end

class AdmonitionFilter < Nanoc::Filter

  identifier :admonition

  def run(content, params = {})
    content.gsub(/^(NOTE|CAUTION): (.*)$/) do |match|
      admonition($1.downcase, $2)
    end
  end

end
