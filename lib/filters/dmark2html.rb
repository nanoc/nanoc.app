require 'dmark'

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  class NanocWsHTMLTranslator < DMark::Translator
    include Nanoc::Helpers::HTMLEscape

    def initialize(tree, items)
      super(tree)

      @items = items
    end

    def handle(node)
      case node
      when DMark::Nodes::RootNode
        handle_children(node)
      when DMark::Nodes::TextNode
        out << h(node.text)
      when DMark::Nodes::ElementNode
        case node.name
        when 'img'
          handle_img(node)
        when 'ref'
          handle_ref(node)
        else
          tags = tags_for(node)

          output_start_tags(tags)
          handle_children(node)
          output_end_tags(tags)
        end
      end
    end

    def output_start_tags(tags)
      tags.each do |tag|
        out << '<'
        out << tag[:name]
        if tag[:attributes]
          tag[:attributes].each_pair do |key, value|
            # TODO: escape
            # TODO: translate

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

    def item_and_frag_for(s)
      pattern, frag = s.split('#', 2)
      item = @items[pattern]
      if item.nil?
        raise "Cannot find an item matching #{pattern} to link to"
      end
      [item, frag]
    end

    def node_for_item_and_frag(item, frag)
      tokens = DMark::Lexer.new(item.raw_content).run
      item_tree = DMark::Parser.new(tokens).run

      node_with_id(frag, parent: item_tree)
    rescue DMark::Lexer::LexerError
      nil
    end

    def handle_ref(node)
      if node.attributes['item']
        target_item, frag = item_and_frag_for(node.attributes['item'])

        target_path = frag ? target_item.path + '#' + frag : target_item.path

        # Find target node
        target_node =
          if @item == target_item
            node_with_id(frag)
          else
            node_for_item_and_frag(target_item, frag)
          end

        # Output
        tags = [{ name: 'a', attributes: { href: target_path } }]
        out << 'the '
        output_start_tags(tags)
        if frag
          out << (target_node ? text_content_of(target_node) : '???')
          out << ' section in the '
        end
        out << target_item[:title]
        out << ' chapter'
        output_end_tags(tags)
      elsif node.attributes['url']
        url = node.attributes['url']
        tags = [{ name: 'a', attributes: { href: url } }]

        output_start_tags(tags)
        handle_children(node)
        output_end_tags(tags)
      elsif node.attributes['frag']
        tags = [{ name: 'a', attributes: { href: '#' + node.attributes['frag'] } }]

        target_node = node_with_id(node.attributes['frag'])
        if target_node.nil?
          raise "Cannot build ref to #{node.attributes['frag']}: no such node"
        end
        content =
          begin
            text_content_of(node)
          rescue
            ''
          end
        if content.empty?
          content =
            if node.attributes['bare']
              text_content_of(target_node)
            else
              'the ' + text_content_of(target_node) + ' section'
            end
        end

        output_start_tags(tags)
        out << content
        output_end_tags(tags)
      else
        raise "Cannot translate ref #{node.inspect}"
      end
    end

    def node_with_id(id, parent: @tree)
      # FIXME: ugly implementation

      if parent.respond_to?(:attributes) && parent.attributes['id'] == id
        parent
      else
        parent.children.each do |child|
          candidate = node_with_id(id, parent: child)
          return candidate if candidate
        end
        nil
      end
    end

    def text_content_of(node)
      if node.nil?
        raise ArgumentError, "Cannot get text content of nil node"
      elsif node.children.size != 1 || !node.children.first.is_a?(DMark::Nodes::TextNode)
        raise "Expected node #{node.name} to have one text child node"
      else
        node.children.first.text
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

        [
          { name: 'pre', attributes: attributes },
          { name: 'code', attributes: code_attributes },
        ]
      when 'emph'
        [{ name: 'em', attributes: attributes }]
      when 'caption'
        [{ name: 'figcaption', attributes: attributes }]
      when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-update', 'uri', 'attribute', 'output'
        [{ name: 'span', attributes: attributes.merge(class: node.name) }]
      when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'li', 'figure', 'blockquote'
        if node.attributes['legacy']
          attributes.merge!(class: 'legacy')
        end
        if node.attributes['nav-title']
          attributes.merge!('data-nav-title': node.attributes['nav-title'])
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
    tokens = DMark::Lexer.new(content).run
    tree = DMark::Parser.new(tokens).run
    NanocWsHTMLTranslator.new(tree, @items).run
  end
end
