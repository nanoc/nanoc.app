class NanocWsLaTeXTranslator < NanocWsCommonTranslator
  SUDO_GEM_CONTENT_DMARK =
    'If the %command{<cmd>} command fails with a permission error, you likely have to prefix ' \
    'the command with %kbd{sudo}. Do not use %command{sudo} until you have tried the command ' \
    'without it; using %command{sudo} when not appropriate will damage your RubyGems installation.'.freeze

  SUDO_GEM_INSTALL_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem install')

  SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem update --system')

  def handle_string(string, context)
    [escape_string(string, context)]
  end

  def handle_element(element, context)
    case element.name
    when 'ref'
      handle_ref(element, context)
    when 'entity'
      handle_entity(element, context)
    when 'erb'
      handle_erb(element, context)
    when 'section'
      depth = context.fetch(:depth, 1) + 1
      handle_children(element, context.merge(depth: depth))
    else
      handle_element_node(element, context)
    end
  end

  def handle_entity(node, context)
    entity = text_content_of(node)

    content =
      case entity
      when 'sudo-gem-install'
        SUDO_GEM_INSTALL_CONTENT_DMARK
      when 'sudo-gem-update-system'
        SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK
      end

    nodes = DMark::Parser.new(content).read_inline_content
    [NanocWsLaTeXTranslator.translate(nodes, context)]
  end

  def handle_erb(node, context)
    ctx = Nanoc::Int::Context.new(context)
    [eval(text_content_of(node), ctx.get_binding)]
  end

  def text_content_of(node)
    case node
    when String
      node
    when DMark::ElementNode
      node.children.map { |c| text_content_of(c) }.join
    else
      raise "Unknown node type: #{node.class}"
    end
  end

  def handle_ref_with_url(node, context, _url)
    [
      handle_children(node, context),
      '\footnote{', escape_string(node.attributes['url'], context), '}'
    ]
  end

  def handle_ref_with_content(node, context, _target_item, _frag)
    # FIXME: ???
    handle_children(node, context)
  end

  def handle_ref_bare(node, context, _target_item, _frag, _target_node)
    handle_children(node, context)
  end

  def handle_ref_insert_section_ref(_node, _context, _target_item, _frag, target_node)
    [
      'the ',
      header_content_of(target_node),
      ' section'
    ]
  end

  def handle_ref_insert_inside_ref(_node, _context, _target_item, _frag, _target_node)
    [
      ' in '
    ]
  end

  def handle_ref_insert_chapter_ref(_node, _context, target_item, _frag)
    [
      'the ',
      target_item[:title],
      ' chapter'
    ]
  end

  def handle_ref_insert_end(_node, _context, target_item, frag, _target_node)
    ref =
      if target_item
        'chap:' + target_item.identifier.to_s
      else
        'section:' + frag
      end

    [
      ' on ',
      '\\cpageref{', ref, '}'
    ]
  end

  def handle_element_node(node, context)
    case node.name
    when 'listing'
      [
        '\\begin{lstlisting}',
        "\n",
        handle_children(node, context.merge(directly_in_lstlisting: true)),
        '\\end{lstlisting}',
        "\n"
      ]
    when 'firstterm'
      [
        '\index{', text_content_of(node), '}',
        wrap_inline('emph', node, context)
      ]
    when 'mark'
      # TODO: handle mark
      handle_children(node, context)
    when 'emph', 'class', 'productname', 'see', 'var', 'log-create', 'log-check-ok', 'log-check-error', 'log-update'
      wrap_inline('emph', node, context)
    when 'strong'
      wrap_inline('textbf', node, context)
    when 'code', 'attribute', 'output'
      wrap_inline('texttt', node, context)
    when 'command', 'kbd'
      names = context[:directly_in_lstlisting] ? %w[textbf] : %w[texttt textbf]
      wrap_inline(names, node, context)
    when 'identifier', 'glob', 'filename', 'uri'
      wrap_inline(%w[emph url], node, context)
    when 'h'
      depth = context.fetch(:depth, 1)
      name =
        case depth
        when 2
          'section'
        when 3
          'subsection'
        when 4
          'subsubsection'
        else
          raise "Unsupported header depth: #{depth}"
        end

      [
        wrap_inline(name, node, context),
        "\n"
      ]
    when 'ul'
      [
        '\\begin{itemize}',
        "\n",
        handle_children(node, context),
        '\\end{itemize}',
        "\n"
      ]
    when 'ol'
      # FIXME: needs to be numbered
      [
        '\\begin{itemize}',
        "\n",
        handle_children(node, context),
        '\\end{itemize}',
        "\n"
      ]
    when 'li'
      [
        '\\item ',
        handle_children(node, context)
      ]
    when 'dl'
      [
        '\\begin{description}',
        "\n",
        handle_children(node, context),
        '\\end{description}',
        "\n"
      ]
    when 'dt'
      [
        '\\item[',
        handle_children(node, context),
        '] '
      ]
    when 'p', 'dd'
      [
        handle_children(node, context),
        "\n\n"
      ]
    when 'log-create', 'log-update', 'prompt'
      handle_children(node, context)
    when 'note', 'tip', 'caution'
      [
        '\\begin{',
        node.name,
        "}\n",
        handle_children(node, context),
        '\\end{',
        node.name,
        "}\n"
      ]
    when 'todo'
      [
        # FIXME: Not actually a note…
        '\\begin{note}',
        "\n",
        handle_children(node, context),
        '\\end{note}',
        "\n"
      ]
    when 'figure', 'img', 'caption'
      # TODO
    when 'blockquote'
      # TODO
    when 'abbr'
      # TODO
      handle_children(node, context)
    else
      raise "Cannot translate #{node.name}"
    end
  end

  ESCAPE_MAP = {
    '^'  => '\\^{}',
    '\\' => '\\textbackslash{}',
    '~'  => '\\ensuremath{\\sim}',
    '|'  => '\\textbar{}',
    '<'  => '\\textless{}',
    '>'  => '\\textgreater{}',
    '-'  => '\\textendash{}'
  }.merge(Hash[*'{}$%&_#'.scan(/./).map { |c| [c, "\\#{c}"] }.flatten])

  ESCAPE_REGEX = Regexp.union(*ESCAPE_MAP.map { |k, _v| k })

  def escape_string(string, context)
    if context[:directly_in_lstlisting]
      string
    else
      string.gsub(ESCAPE_REGEX) do |m|
        ESCAPE_MAP[m]
      end
    end
  end

  LSTLISTING_ESCAPE_BEGIN = '(*@'.freeze
  LSTLISTING_ESCAPE_END = '@*)'.freeze

  def escape_lstlisting(s)
    LSTLISTING_ESCAPE_BEGIN + s + LSTLISTING_ESCAPE_END
  end

  def wrap_inline(x, node, context)
    out = []

    names =
      case x
      when Array
        x
      when String
        [x]
      else
        raise ArgumentError
      end

    out << LSTLISTING_ESCAPE_BEGIN if context[:directly_in_lstlisting]

    names.each { |name| out << '\\' << name << '{' }
    out << handle_children(node, context.merge(directly_in_lstlisting: false))
    names.each { |_name| out << '}' }

    out << LSTLISTING_ESCAPE_END if context[:directly_in_lstlisting]

    out
  end
end
