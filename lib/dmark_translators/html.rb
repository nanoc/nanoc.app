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

      attributes = { id: id }
      attributes = attributes.merge('data-nav-title' => element.attributes['nav-title']) if element.attributes['nav-title']
      wrap("h#{depth}", attributes) { handle_children(element, context) }
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
      attributes[:class] = 'legacy-intermediate' if element.attributes['legacy-intermediate']
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
      raise "Cannot translate #{element.name}"
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
    pre_classes << 'legacy-intermediate' if element.attributes['legacy-intermediate']
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

  def handle_ref_with_url(node, context, url)
    wrap('a', href: url) { handle_children(node, context) }
  end

  def handle_ref_with_content(node, context, target_item, frag)
    href = href_for(target_item, frag)
    wrap('a', href: href) { handle_children(node, context) }
  end

  def handle_ref_bare(node, context, target_item, frag, target_node)
    href = href_for(target_item, frag)
    wrap('a', href: href) do
      if frag
        text_content_of(target_node)
      else
        target_item[:title]
      end
    end
  end

  def handle_ref_insert_section_ref(node, context, target_item, frag, target_node)
    href = href_for(target_item, frag)
    [
      'the ',
      wrap('a', href: href) { text_content_of(target_node) },
      ' section'
    ]
  end

  def handle_ref_insert_inside_ref(node, context, target_item, frag, target_node)
    [
      ' on '
    ]
  end

  def handle_ref_insert_chapter_ref(node, context, target_item, frag)
    [
      'the ',
      wrap('a', href: target_item.path) { target_item[:title] },
      ' page'
    ]
  end

  def handle_ref_insert_end(node, context, target_item, frag, target_node)
    []
  end

  def href_for(target_item, frag)
    if frag
      target_item.path + '#' + frag
    else
      target_item.path
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
