require 'set'
require 'kramdown/converter'

Class.new(Nanoc::Filter) do
  identifier :latex2pdf
  type :text => :binary

  def run(content, params = {})
    unless system('which', 'xelatex', out: '/dev/null')
      $stderr.puts "Warning: `xelatex` not found; PDF generation disabled."
      File.write(output_filename, '')
      return
    end

    Tempfile.open(['nanoc-latex', '.tex']) do |f|
      f.write(content)
      f.flush

      3.times do
        system('xelatex', '-halt-on-error', '-output-directory', File.dirname(f.path), f.path)
      end

      system('mv', f.path.sub('.tex', '.pdf'), output_filename)
    end
  end
end

Class.new(Nanoc::Filter) do
  identifier :kramdown_latex

  def run(content, params = {})
    params = params.merge(
      latex_headers: %w(chapter section subsection subsubsection paragraph subparagraph),
      input: @item.identifier.ext == 'erb' ? 'html' : 'kramdown',
    )

    document = ::Kramdown::Document.new(content, params)

    document.warnings.each do |warning|
      $stderr.puts "kramdown warning: #{warning}"
    end

    document.to_nanoc_ws_latex
  end
end

Class.new(Nanoc::Filter) do
  identifier :remove_pre_code_language

  def run(content, params = {})
    content.lines.reject { |l| l =~ /^\s+#!/ }.join
  end
end

module Kramdown
  module Converter
    class NanocWsLatex < ::Kramdown::Converter::Latex
      def convert_codeblock(el, opts)
        (latex_link_target(el) || '') +
        "\\begin{lstlisting}\n" +
        el.value + "\n" +
        "\\end{lstlisting}\n"
      end

      ESCAPE_MAP = {
        "^"  => "\\^{}",
        "\\" => "\\textbackslash{}",
        "~"  => "\\ensuremath{\\sim}",
        "|"  => "\\textbar{}",
        "<"  => "\\textless{}",
        ">"  => "\\textgreater{}",
        "-"  => "\\textendash{}",
      }.merge(Hash[*("{}$%&_#".scan(/./).map {|c| [c, "\\#{c}"]}.flatten)])

      ESCAPE_RE = Regexp.union(*ESCAPE_MAP.map { |k, _v| k })

      def escape(str, opts = {})
        str.gsub(ESCAPE_RE) do |m|
          if opts[:nanocws_need_lstlisting_escape]
            escape_lstlisting(ESCAPE_MAP[m])
          else
            ESCAPE_MAP[m]
          end
        end
      end

      def convert_text(el, opts)
        escape(el.value, opts)
      end

      def convert_html_element(el, opts)
        classes = (el.attr['class'] || '').split(/\s+/)

        orig_opts = opts
        opts = opts.merge(nanocws_need_lstlisting_escape: false)

        val =
          case el.value
          when 'pre'
            (latex_link_target(el) || '') +
            "\\begin{lstlisting}\n" +
            inner(el, opts.merge(nanocws_need_lstlisting_escape: true)) + "\n" +
            "\\end{lstlisting}\n"
          when 'i', 'em'
            "\\emph{#{inner(el, opts)}}"
          when 'b', 'strong',
            "\\textbf{#{inner(el, opts)}}"
          when 'kbd'
            texttt(opts, "\\textbf{#{inner(el, opts)}}")
          when 'code'
            texttt(opts, inner(el, opts))
          when 'var'
            texttt(opts, "\\textit{#{inner(el, opts)}}")
          when 'p'
            "\n\n" + inner(el, opts) + "\n\n"
          when 'h2'
            "\\section*{" + inner(el, opts).strip + "}\n\n"
          when 'a'
            # FIXME: convert to cross-reference or footnote with URL
            inner(el, opts)
          when 'div'
            if classes.include?('admonition')
              inner(el, opts)
            elsif classes.include?('admonition-wrapper')
              kind =
                if classes.include?('tip')
                  'tip'
                elsif classes.include?('note')
                  'note'
                elsif classes.include?('caution')
                  'caution'
                else
                  raise "Unknown admonition type: #{classes}"
                end

              "\\begin{#{kind}}\n#{inner(el, opts)}\n\\end{#{kind}}\n"
            else
              cannot_convert(el)
            end
          when 'dl'
            latex_environment('description', el, inner(el, opts))
          when 'dd'
            "#{latex_link_target(el)}#{inner(el, opts)}\n\n"
          when 'dt'
            "\\item[#{inner(el, opts)}] "
          when 'span'
            if classes.include?('firstterm')
              "\\emph{#{inner(el, opts)}}"
            elsif classes.include?('filename')
              "\\emph{#{inner(el, opts)}}"
            elsif classes.include?('uri')
              "\\emph{#{inner(el, opts)}}"
            elsif classes.include?('productname')
              "\\emph{#{inner(el, opts)}}"
            elsif classes.include?('see')
              "\\emph{#{inner(el, opts)}}"
            elsif classes.include?('command')
              texttt(opts, "\\textbf{#{inner(el, opts)}}")
            elsif classes.include?('prompt')
              texttt(opts, inner(el, opts))
            elsif classes.include?('log-check-error')
              texttt(opts, inner(el, opts))
            elsif classes.include?('log-check-ok')
              texttt(opts, inner(el, opts))
            elsif classes.include?('log-create')
              texttt(opts, inner(el, opts))
            elsif classes.include?('log-update')
              texttt(opts, inner(el, opts))
            elsif classes.include?('attribute')
              texttt(opts, inner(el, opts))
            else
              cannot_convert(el)
            end
          when 'abbr'
            if el.attr['title']
              "\\emph{#{el.attr['title']}} (#{inner(el, opts)})"
            else
              cannot_convert(el)
            end
          else
            cannot_convert(el)
          end

        if orig_opts[:nanocws_need_lstlisting_escape]
          escape_lstlisting(val)
        else
          val
        end
      end

      LSTLISTING_ESCAPE_BEGIN = '(*@'
      LSTLISTING_ESCAPE_END = '@*)'

      def escape_lstlisting(s)
        LSTLISTING_ESCAPE_BEGIN + s + LSTLISTING_ESCAPE_END
      end

      def texttt(opts, s)
        if opts[:parent].value == 'pre'
          s
        else
          "\\texttt{#{s}}"
        end
      end

      def cannot_convert(el)
        warn("Can't convert element: #{el.type} #{el.value} class=#{el.attr['class']}")
        ''
      end
    end
  end
end
