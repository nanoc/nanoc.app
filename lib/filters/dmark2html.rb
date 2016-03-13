require 'd-mark'

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  class NanocWsHTMLTranslator < DMark::Translator
    include Nanoc::Helpers::HTMLEscape

    def initialize(nodes, items, item, binding_x)
      super(nodes)

      @items = items
      @item = item
      @binding = binding_x
    end

    def handle_string(string)
      out << h(string)
    end

    def handle_element(element, path)
      case element.name
      when 'img'
        handle_img(element)
      when 'ref'
        handle_ref(element, path)
      when 'entity'
        handle_entity(element)
      when 'erb'
        handle_erb(element)
      when 'section'
        handle_children(element, path)
      when 'h'
        depth = path.count { |node| node.name == 'section' } + 1
        wrap("h#{depth}") { handle_children(element, path) }
      else
        tags = tags_for(element)
        if tags.nil?
          p tags
          p element
        end

        output_start_tags(tags)
        handle_children(element, path)
        output_end_tags(tags)
      end
    end

    def wrap(name, params = {})
      params_string = params.map { |k, v| " #{k}=\"#{html_escape(v)}\"" }.join('')
      out << "<#{name}#{params_string}>"
      yield
      out << "</#{name}>"
    end

    def output_start_tags(tags)
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
    end

    def output_end_tags(tags)
      tags.reverse_each do |tag|
        out << "</#{tag[:name]}>"
      end
    end

    def handle_img(node)
      src = text_content_of(node)
      tags = [{ name: 'img', attributes: { src: src } }]
      output_start_tags(tags)
    end

    def nodes_for_item(item)
      if item.identifier.ext == 'dmark'
        DMark::Parser.new(item.raw_content).parse
      else
        nil
      end
    end

    def handle_ref(node, path)
      if node.attributes['url']
        url = node.attributes['url']
        tags = [{ name: 'a', attributes: { href: url } }]

        output_start_tags(tags)
        handle_children(node, path)
        output_end_tags(tags)
        return
      end

      target_item = node.attributes['item'] ? @items[node.attributes['item']] : @item
      raise "%ref error: canot find item for #{node.attributes['item'].inspect}" if target_item.nil?

      target_frag = node.attributes['frag']
      target_path = target_frag ? target_item.path + '#' + target_frag : target_item.path
      target_nodes = @item == target_item ? @nodes : nodes_for_item(target_item)
      target_node = (target_nodes && target_frag) ? node_with_id(target_frag, nodes: target_nodes) : nil
      # FIXME: require target_nodes

      tags = [{ name: 'a', attributes: { href: target_path } }]
      if has_content?(node)
        output_start_tags(tags)
        handle_children(node, path)
        output_end_tags(tags)
      else
        if node.attributes['bare']
          output_start_tags(tags)
          out << (target_frag ? safe_text_content_of(target_node, target_item, target_frag) : target_item[:title])
          output_end_tags(tags)
        else
          out << 'the '

          if target_frag
            output_start_tags(tags)
            out << safe_text_content_of(target_node, target_item, target_frag)
            output_end_tags(tags)
            out << ' section'
          end

          if target_frag && target_item != @item
            out << ' on the '
          end

          if target_item != @item
            item_tags = [{ name: 'a', attributes: { href: target_item.path } }]
            output_start_tags(item_tags)
            out << target_item[:title]
            output_end_tags(item_tags)
            out << ' page'
          end
        end
      end
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
      out << NanocWsHTMLTranslator.new(nodes, @items, @item, @binding).run
    end

    def handle_erb(node)
      out << eval(text_content_of(node), @binding)
    end

    def safe_text_content_of(node, item, frag)
      text_content_of(node)
    rescue
      $stderr.puts "WARNING: failed to get text content for item=#{item.identifier} frag=#{frag}; falling back to `???`"
      '???'
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

    def node_with_id(id, nodes: @nodes)
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

  def run(content, params = {})
    nodes = DMark::Parser.new(content).parse
    NanocWsHTMLTranslator.new(nodes, @items, @item, binding).run
  end
end
