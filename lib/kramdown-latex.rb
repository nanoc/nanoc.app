require 'kramdown/converter'

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
