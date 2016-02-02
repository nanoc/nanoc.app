require 'dmark'

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  class NanocWsHTMLTranslator < DMark::Translator
    include Nanoc::Helpers::HTMLEscape

    def initialize(tree, items, item)
      super(tree)

      @items = items
      @item = item
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

    def tree_for(item)
      # FIXME: raw_content is not good enough
      tokens = DMark::Lexer.new(item.raw_content).run
      DMark::Parser.new(tokens).run
    rescue DMark::Lexer::LexerError
      nil
    end

    def handle_ref(node)
      if node.attributes['url']
        url = node.attributes['url']
        tags = [{ name: 'a', attributes: { href: url } }]

        output_start_tags(tags)
        handle_children(node)
        output_end_tags(tags)
        return
      end

      target_item = node.attributes['item'] ? @items[node.attributes['item']] : @item
      raise "%ref error: canot find item for #{node.attributes['item'].inspect}" if target_item.nil?

      target_frag = node.attributes['frag']
      target_path = target_frag ? target_item.path + '#' + target_frag : target_item.path
      target_tree = @item == target_item ? @tree : tree_for(target_item)
      target_node = target_tree && target_frag ? node_with_id(target_frag, tree: target_tree) : nil
      # FIXME: require target_tree

      content =
        begin
          text_content_of(node)
        rescue
          nil
        end

      tags = [{ name: 'a', attributes: { href: target_path } }]
      if content
        output_start_tags(tags)
        out << content
        output_end_tags(tags)
      else
        if node.attributes['bare']
          output_start_tags(tags)
          out << (target_frag ? safe_text_content_of(target_node, target_item, target_frag) : target_item[:title])
          output_end_tags(tags)
        else
          if target_frag
            out << 'the '
            output_start_tags(tags)
            out << safe_text_content_of(target_node, target_item, target_frag)
            output_end_tags(tags)
            out << ' section'
          end

          if target_frag && target_item != @item
            out << ' in the '
          end

          if target_item != @item
            out << ' in the '
            out << target_item[:title]
            out << ' chapter'
          end
        end
      end
    end

    def safe_text_content_of(node, item, frag)
      text_content_of(node)
    rescue
      $stderr.puts "WARNING: failed to get text content for item=#{item.identifier} frag=#{frag}; falling back to `???`"
      '???'
    end

    def node_with_id(id, tree: @tree)
      # FIXME: ugly implementation

      if tree.respond_to?(:attributes) && tree.attributes['id'] == id
        tree
      else
        tree.children.each do |child|
          candidate = node_with_id(id, tree: child)
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
      when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-check-ok', 'log-check-error', 'log-update', 'uri', 'attribute', 'output'
        [{ name: 'span', attributes: attributes.merge(class: node.name) }]
      when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'li', 'figure', 'blockquote', 'var'
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
    NanocWsHTMLTranslator.new(tree, @items, @item).run
  end
end
