# frozen_string_literal: true

def doc_toc
  out = +''

  @config[:toc].each do |section|
    out << "<div class=section-title>#{section[:title]}</div>"
    out << '<ul class="toc">'
    section[:children].each do |child_glob|
      out << '<li>'
      if @item.identifier =~ child_glob
        out << '<span class=active>' << title_of_id(child_glob) << '</span>'
        out << '{{TOC}}'
      else
        out << link_to_id(child_glob)
      end
      out << '</li>'
    end
    out << '</ul>'
  end

  out
end
