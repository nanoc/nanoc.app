require 'd-mark'

Class.new(Nanoc::Filter) do
  identifier :dmark2latex

  class NanocWsLaTeXTranslator < DMark::Translator
    def initialize(nodes, item, items, binding_x)
      super(nodes)

      @item = item
      @items = items
      @binding = binding_x
    end

    def handle(node, options = {})
      case node
      when String
        out << escape_string(node, options)
      when DMark::Parser::ElementNode
        case node.name
        when 'ref'
          handle_ref(node, options)
        when 'entity'
          handle_entity(node)
        when 'erb'
          handle_erb(node)
        else
          handle_element_node(node, options)
        end
      end
    end

    def handle_children(node, options)
      node.children.each { |child| handle(child, options) }
    end

    SUDO_GEM_CONTENT_DMARK = 'If the %command{<cmd>} command fails with a permission error, you likely have to prefix the command with %kbd{sudo}. Do not use %command{sudo} until you have tried the command without it; using %command{sudo} when not appropriate will damage your RubyGems installation.'

    SUDO_GEM_INSTALL_CONTENT_DMARK = SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem install')

    SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK = SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem update --system')

    def handle_entity(node)
      entity = text_content_of(node)

      content =
        case entity
        when 'sudo-gem-install'
          SUDO_GEM_INSTALL_CONTENT_DMARK
        when 'sudo-gem-update-system'
          SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK
        end

      nodes = DMark::Parser.new(content).read_inline_content
      out << NanocWsLaTeXTranslator.new(nodes, @items, @item, @binding).run
    end

    def handle_erb(node)
      out << eval(text_content_of(node), @binding)
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
      if node.children.size != 1 || !node.children.first.is_a?(String)
        raise "Expected node #{node.name} to have one text child node"
      else
        node.children.first
      end
    end

    def handle_element_node(node, options)
      case node.name
      when 'listing'
        out << '\\begin{lstlisting}' << "\n"
        handle_children(node, options.merge(directly_in_lstlisting: true))
        out << '\\end{lstlisting}' << "\n"
      when 'emph', 'firstterm', 'class', 'productname', 'see', 'var', 'log-create', 'log-check-ok', 'log-check-error', 'log-update'
        wrap_inline('emph', node, options)
      when 'strong'
        wrap_inline('textbf', node, options)
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
      when 'ol'
        # FIXME: needs to be numbered
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
        out << '\\begin{' << node.name << "}\n"
        handle_children(node, options)
        out << '\\end{' << node.name << "}\n"
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
    nodes = DMark::Parser.new(content.sub(/\A\n/, '')).parse
    NanocWsLaTeXTranslator.new(nodes, @item, @items, binding).run
  end
end
