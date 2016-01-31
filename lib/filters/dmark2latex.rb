require 'dmark'

Class.new(Nanoc::Filter) do
  identifier :dmark2latex

  class NanocWsLaTeXTranslator < DMark::Translator
    def initialize(tree, item, items)
      super(tree)

      @item = item
      @items = items
    end

    def handle(node, options = {})
      case node
      when DMark::Nodes::RootNode
        handle_children(node, options)
      when DMark::Nodes::TextNode
        out << escape_string(node.text, options)
      when DMark::Nodes::ElementNode
        case node.name
        when 'ref'
          handle_ref(node, options)
        else
          handle_element_node(node, options)
        end
      end
    end

    def handle_children(node, options)
      node.children.each { |child| handle(child, options) }
    end

    def handle_ref(node, options)
      if node.attributes['item']
        pattern, frag = node.attributes['item'].split('#', 2)
        item = @items[pattern]
        if item.nil?
          raise "Cannot find an item matching pattern #{pattern.inspect} to link to"
        end

        out << 'the '
        if node.attributes['frag']
          out << 'relevant section'
          out << ' in the '
        end
        out << item[:title]
        out << ' chapter on '
        out << '\\cpageref{chap:' << item.identifier << '}'
      elsif node.attributes['url']
        # TODO
      elsif node.attributes['frag']
        # TODO
        handle_children(node, options)
      else
        raise "Cannot translate ref #{node.inspect}"
      end
    end

    def text_content_of(node)
      if node.children.size != 1 || !node.children.first.is_a?(DMark::Nodes::TextNode)
        raise "Expected node #{node.name} to have one text child node"
      else
        node.children.first.text
      end
    end

    def handle_element_node(node, options)
      case node.name
      when 'listing'
        out << '\\begin{lstlisting}' << "\n"
        handle_children(node, options.merge(directly_in_lstlisting: true))
        out << '\\end{lstlisting}' << "\n"
      when 'emph', 'firstterm', 'class', 'productname', 'see'
        wrap_inline('emph', node, options)
      when 'code', 'attribute', 'output'
        wrap_inline('texttt', node, options)
      when 'command', 'kbd'
        names = options[:directly_in_lstlisting] ? %w( textbf ) : %w( texttt textbf )
        wrap_inline(names, node, options)
      when 'identifier', 'glob', 'filename', 'uri'
        wrap_inline(%w( emph url ), node, options)
      when 'h2'
        wrap_inline('section', node, options)
        out << "\n"
      when 'h3'
        wrap_inline('subsection', node, options)
        out << "\n"
      when 'ul'
        out << '\\begin{itemize}' << "\n"
        handle_children(node, options)
        out << '\\end{itemize}' << "\n"
      when 'li'
        out << '\\item '
        handle_children(node, options)
      when 'dl'
        out << '\\begin{description}' << "\n"
        handle_children(node, options)
        out << '\\end{description}' << "\n"
      when 'dt'
        out << '\\item['
        handle_children(node, options)
        out << '] '
      when 'p', 'dd'
        handle_children(node, options)
        out << "\n"
      when 'log-create', 'log-update', 'prompt'
        handle_children(node, options)
      when 'note', 'tip', 'caution'
        # TODO
      when 'figure', 'img', 'caption'
        # TODO
      when 'blockquote'
        # TODO
      else
        raise "Cannot translate #{node.name}"
      end
    end

    ESCAPE_MAP = {
      "^"  => "\\^{}",
      "\\" => "\\textbackslash{}",
      "~"  => "\\ensuremath{\\sim}",
      "|"  => "\\textbar{}",
      "<"  => "\\textless{}",
      ">"  => "\\textgreater{}",
      "-"  => "\\textendash{}",
    }.merge(Hash[*("{}$%&_#".scan(/./).map { |c| [c, "\\#{c}"] }.flatten)])

    ESCAPE_REGEX = Regexp.union(*ESCAPE_MAP.map { |k, _v| k })

    def escape_string(string, options)
      if options[:directly_in_lstlisting]
        string
      else
        string.gsub(ESCAPE_REGEX) do |m|
          ESCAPE_MAP[m]
        end
      end
    end

    LSTLISTING_ESCAPE_BEGIN = '(*@'
    LSTLISTING_ESCAPE_END = '@*)'

    def escape_lstlisting(s)
      LSTLISTING_ESCAPE_BEGIN + s + LSTLISTING_ESCAPE_END
    end

    def wrap_inline(x, node, options)
      names =
        case x
        when Array
          x
        when String
          [x]
        else
          raise ArgumentError
        end

      if options[:directly_in_lstlisting]
        out << LSTLISTING_ESCAPE_BEGIN
      end

      names.each { |name| out << '\\' << name << '{' }
      handle_children(node, options.merge(directly_in_lstlisting: false))
      names.each { |_name| out << '}' }

      if options[:directly_in_lstlisting]
        out << LSTLISTING_ESCAPE_END
      end
    end
  end

  def run(content, params = {})
    tokens = DMark::Lexer.new(content).run
    tree = DMark::Parser.new(tokens).run
    NanocWsLaTeXTranslator.new(tree, @item, @items).run
  end
end
