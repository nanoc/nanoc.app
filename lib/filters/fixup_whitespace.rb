# encoding: utf-8

class NanocSite::FixupWhitespace < ::Nanoc::Filter

  identifier :fixup_whitespace

  def run(content, params={})
    # Necessary because Nokogiri adds a newline
    content.gsub("<li>\n<a href=", '<li><a href=')
  end

end
