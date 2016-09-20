require 'kramdown/converter'

module Kramdown
  module Converter
    class NanocWsDmark < Base
      def convert(el, opts = {})
        send("convert_#{el.type}", el, opts)
      end

      def inner(el, opts)
        ''.tap do |buf|
          el.children.each_with_index do |inner_el, index|
            buf << send("convert_#{inner_el.type}", inner_el, options)
          end
        end
      end

      def convert_root(el, opts)
        inner(el, opts)
      end

      def convert_p(el, opts)
        "#p\n" + inner(el, opts).lines.map { |l| '  ' + l.strip }.join("\n") + "\n"
      end

      def convert_blank(el, opts)
        "\n"
      end

      def convert_text(el, opts)
        escape(el.value)
      end

      def convert_typographic_sym(el, opts)
        case el.value
        when :hellip
          '…'
        else
          raise "Unknown typographic symbol: #{el.value}"
        end
      end

      def convert_codespan(el, opts)
        "%code{#{escape(el.value)}}"
      end

      def escape(str)
        str.gsub('%', '%%').gsub('{', '%{')
      end
    end
  end
end
