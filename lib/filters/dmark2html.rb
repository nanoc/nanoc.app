require 'd-mark'

class NanocWsHTMLTranslator < DMark::Translator
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
    when 'section'
      depth = context.fetch(:depth, 1) + 1
      handle_children(element, context.merge(depth: depth))
    when 'h'
      depth = context.fetch(:depth, 1)
      wrap("h#{depth}") { handle_children(element, context) }
    else
      wrap_tags(
        tags_for(element),
        handle_children(element, context),
      )
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
    src = text_content_of(node)
    tags = [{ name: 'img', attributes: { src: src } }]
    start_tags_for(tags)
  end

  def handle_ref(node, context)
    if node.attributes['url']
      url = node.attributes['url']
      tags = [{ name: 'a', attributes: { href: url } }]

      return wrap_tags(tags, handle_children(node, context))
    end

    target_item = node.attributes['item'] ? context[:items][node.attributes['item']] : context[:item]
    raise "%ref error: canot find item for #{node.attributes['item'].inspect}" if target_item.nil?

    target_frag = node.attributes['frag']
    target_path = target_frag ? target_item.path + '#' + target_frag : target_item.path
    target_nodes = context[:item] == target_item ? context[:nodes] : nodes_for_item(target_item)
    target_node = (target_nodes && target_frag) ? node_with_id(target_frag, nodes: target_nodes) : nil

    tags = [{ name: 'a', attributes: { href: target_path } }]
    if has_content?(node)
      wrap_tags(tags, handle_children(node, context))
    else
      if node.attributes['bare']
        out = (target_frag ? text_content_of(target_node) : target_item[:title])

        wrap_tags(tags, out)
      else
        out = []
        out << 'the '

        if target_frag
          out << wrap_tags(tags, text_content_of(target_node))
          out << ' section'
        end

        if target_frag && target_item != context[:item]
          out << ' on the '
        end

        if target_item != context[:item]
          item_tags = [{ name: 'a', attributes: { href: target_item.path } }]
          out << wrap_tags(item_tags, target_item[:title])
          out << ' page'
        end
      end

      out
    end
  end

  # Helper methods

  def wrap(name, params = {})
    params_string = params.map { |k, v| " #{k}=\"#{html_escape(v)}\"" }.join('')

    [
      "<#{name}#{params_string}>",
      yield,
      "</#{name}>",
    ]
  end

  def nodes_for_item(item)
    if item.identifier.ext == 'dmark'
      DMark::Parser.new(item.raw_content).parse
    else
      nil
    end
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

  # Helper methods - deprecated

  def wrap_tags(tags, subj)
    [
      start_tags_for(tags),
      subj,
      end_tags_for(tags),
    ]
  end

  def start_tags_for(tags)
    out = ''
    tags.each do |tag|
      out << '<'
      out << tag[:name]
      if tag[:attributes]
        tag[:attributes].each_pair do |key, value|
          out << ' '
          out << key.to_s
          out << '="'
          out << h(value)
          out << '"'
        end
      end
      out << '>'
    end

    [out]
  end

  def end_tags_for(tags)
    tags.reverse_each.map { |tag| ["</#{tag[:name]}>"] }
  end

  def has_content?(node)
    if node.nil? || node.children.empty?
      false
    elsif node.children.any? { |n| !n.is_a?(String) }
      true
    elsif node.children.all? { |s| s.empty? }
      false
    else
      true
    end
  end

  def node_with_id(id, nodes:)
    # FIXME: ugly implementation

    candidate = nodes.find { |n| n.is_a?(DMark::ElementNode) && n.attributes['id'] == id }
    return candidate if candidate

    nodes.each do |node|
      case node
      when String
      when DMark::ElementNode
        candidate = node_with_id(id, nodes: node.children)
        return candidate if candidate
      end
    end

    nil
  end

  def tags_for(node)
    # returns e.g. [{name: 'pre', attributes: {}}]

    attributes = {}

    if node.attributes['id']
      attributes.merge!(id: node.attributes['id'])
    end

    case node.name
    when 'listing'
      code_attributes = {}
      if node.attributes['lang']
        code_attributes[:class] = "language-#{node.attributes['lang']}"
      end
      classes = []
      classes << 'template' if node.attributes['template']
      classes << 'legacy' if node.attributes['legacy']
      classes << 'new' if node.attributes['new']
      attributes[:class] = classes.join(' ') if classes.any?

      [
        { name: 'pre', attributes: attributes },
        { name: 'code', attributes: code_attributes },
      ]
    when 'emph'
      [{ name: 'em', attributes: attributes }]
    when 'abbr'
      if node.attributes['title']
        attributes[:title] = node.attributes['title']
      end
      [{ name: 'abbr', attributes: attributes }]
    when 'caption'
      [{ name: 'figcaption', attributes: attributes }]
    when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-check-ok', 'log-check-error', 'log-update', 'uri', 'attribute', 'output'
      [{ name: 'span', attributes: attributes.merge(class: node.name) }]
    when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'ol', 'li', 'figure', 'blockquote', 'var', 'strong', 'section'
      if node.attributes['legacy']
        attributes[:class] = 'legacy'
      end
      if node.attributes['new']
        attributes[:class] = 'new'
      end
      if node.attributes['spacious']
        attributes[:class] = 'spacious'
      end
      if node.attributes['nav-title']
        attributes[:'data-nav-title'] = node.attributes['nav-title']
      end
      if node.name =~ /\Ah\d/
        attributes[:id] = text_content_of(node).downcase.gsub(/\W+/, '-').gsub(/^-|-$/, '')
      end
      [{ name: node.name, attributes: attributes }]
    when 'note', 'tip', 'caution'
      [
        { name: 'div', attributes: attributes.merge(class: "admonition-wrapper #{node.name}") },
        { name: 'div', attributes: attributes.merge(class: 'admonition') },
      ]
    else
      raise "Cannot translate #{node.name}"
    end
  end
end

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  def run(content, params = {})
    nodes = DMark::Parser.new(content).parse
    context = { items: @items, item: @item, nodes: nodes, binding: binding }
    NanocWsHTMLTranslator.translate(nodes, context)
  rescue => e
    case e
    when DMark::Parser::ParserError
      line = content.lines[e.line_nr]

      lines = [
        e.message,
        "",
        line,
        "\e[31m" + ' ' * e.col_nr + '↑' + "\e[0m",
      ]

      fancy_msg = lines.map { |l| "\e[34m[D*Mark]\e[0m #{l.strip}\n" }.join('')
      raise "D*Mark parser error\n" + fancy_msg
    else
      raise e
    end
  end
end
