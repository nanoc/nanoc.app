module Nanoc3::Filters

  class SyntaxColorize < Nanoc3::Filter

    identifiers :syntax_colorize

    def run(content, params={})
      require 'coderay'
      require 'nokogiri'

      doc = Nokogiri::HTML(content)

      doc.css('pre code[@class*=language-]').each do |e|
        # Get language
        lang = /language-([a-z0-9\-_]+)/.match(e['class'])[1]

        # Get text
        lines = e.inner_text.split("\n")
        min_indent = lines.inject(nil) do |memo, line|
          next memo if line =~ /^\s*$/
          next memo if line !~ /^(\s*)/
          [ memo, $1.size ].compact.min
        end
        lines.each do |line|
          line[0,min_indent] = ''
        end
        subcontent = lines.join("\n")

        # Process
        e.inner_html = ::CodeRay.scan(subcontent, lang).html(params)
      end

      doc.to_s
    end

  end

end
