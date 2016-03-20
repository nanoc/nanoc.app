class NanocWsHTMLTranslator < NanocWsCommonTranslator
  include Nanoc::Helpers::HTMLEscape

  SUDO_GEM_CONTENT_DMARK =
    'If the %command{<cmd>} command fails with a permission error, you likely have to prefix ' \
    'the command with %kbd{sudo}. Do not use %command{sudo} until you have tried the command ' \
    'without it; using %command{sudo} when not appropriate will damage your RubyGems installation.'

  SUDO_GEM_INSTALL_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem install')

  SUDO_GEM_UPDATE_SYSTEM_CONTENT_DMARK =
    SUDO_GEM_CONTENT_DMARK.gsub('<cmd>', 'gem update --system')

  # Abstract methods

  def handle_string(string, context)
    [h(string)]
  end

  def handle_element(element, context)
    case element.name
    when 'img'
      handle_img(element, context)
    when 'ref'
      handle_ref(element, context)
    when 'entity'
      handle_entity(element, context)
    when 'erb'
      handle_erb(element, context)
    when 'listing'
      handle_listing(element, context)
    when 'section'
      depth = context.fetch(:depth, 1) + 1
      handle_children(element, context.merge(depth: depth))
    when 'h'
      depth = context.fetch(:depth, 1)
      id = to_id(text_content_of(element))
      wrap("h#{depth}", id: id) { handle_children(element, context) }
    when 'emph'
      wrap('em') { handle_children(element, context) }
    when 'abbr'
      attributes = element.attributes['title'] ? { title: element.attributes['title'] } : {}
      wrap('abbr', attributes) { handle_children(element, context) }
    when 'caption'
      wrap('figcaption') { handle_children(element, context) }
    when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-check-ok', 'log-check-error', 'log-update', 'uri', 'attribute', 'output'
      wrap('span', class: element.name) { handle_children(element, context) }
    when 'note', 'tip', 'caution', 'todo'
      wrap('div', class: "admonition-wrapper #{element.name}") do
        wrap('div', class: "admonition") do
          handle_children(element, context)
        end
      end
    when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'ol', 'li', 'figure', 'blockquote', 'var', 'strong', 'section'
      attributes = {}

      attributes[:class] = 'legacy' if element.attributes['legacy']
      attributes[:class] = 'new' if element.attributes['new']
      attributes[:class] = 'spacious' if element.attributes['spacious']
      attributes[:'data-nav-title'] = element.attributes['nav-title'] if element.attributes['nav-title']

      if element.attributes['id']
        attributes[:id] = element.attributes['id']
      elsif element.name =~ /\Ah\d/
        attributes[:id] = to_id(text_content_of(element))
      end

      wrap(element.name, attributes) { handle_children(element, context) }
    else
      raise "Cannot translate #{node.name}"
    end
  end

  # Specific elements

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
    [NanocWsHTMLTranslator.translate(nodes, context)]
  end

  def handle_erb(node, context)
    [eval(text_content_of(node), context.fetch(:binding))]
  end

  def handle_img(node, context)
    wrap_empty('img', src: text_content_of(node))
  end

  def handle_listing(element, context)
    code_attributes = {}

    pre_classes = []
    pre_classes << 'template' if element.attributes['template']
    pre_classes << 'legacy' if element.attributes['legacy']
    pre_classes << 'new' if element.attributes['new']
    pre_attrs =
      if pre_classes.any?
        { class: pre_classes.join(' ') }
      else
        {}
      end

    code_attrs =
      if element.attributes['lang']
        { class: 'language-' + element.attributes['lang'] }
      else
        {}
      end

    wrap('pre', pre_attrs) do
      wrap('code', code_attrs) do
        handle_children(element, context)
      end
    end
  end

  def handle_ref(node, context)
    if node.attributes['url']
      href = node.attributes['url']
      return wrap('a', href: href) { handle_children(node, context) }
    end

    target_item = node.attributes['item'] ? context[:items][node.attributes['item']] : context[:item]
    raise "%ref error: canot find item for #{node.attributes['item'].inspect}" if target_item.nil?

    target_frag = node.attributes['frag']
    target_path = target_frag ? target_item.path + '#' + target_frag : target_item.path
    target_nodes = context[:item] == target_item ? context[:nodes] : nodes_for_item(target_item)
    target_node = (target_nodes && target_frag) ? node_with_id(target_frag, nodes: target_nodes) : nil

    if has_content?(node)
      wrap('a', href: target_path) { handle_children(node, context) }
    else
      if node.attributes['bare']
        wrap('a', href: target_path) do
          if target_frag
            text_content_of(target_node)
          else
            target_item[:title]
          end
        end
      else
        out = []
        out << 'the '

        if target_frag
          out << wrap('a', href: target_path) { text_content_of(target_node) }
          out << ' section'
        end

        if target_frag && target_item != context[:item]
          out << ' on the '
        end

        if target_item != context[:item]
          out << wrap('a', href: target_item.path) { target_item[:title] }
          out << ' page'
        end
      end

      out
    end
  end

  # Helper methods

  def wrap(name, params = {})
    [
      start_tag(name, params),
      yield,
      end_tag(name),
    ]
  end

  def wrap_empty(name, params = {})
    [start_tag(name, params)]
  end

  def start_tag(name, params)
    '<' + name + params.map { |k, v| " #{k}=\"#{html_escape(v)}\"" }.join('') + '>'
  end

  def end_tag(name)
    '</' + name + '>'
  end
end
