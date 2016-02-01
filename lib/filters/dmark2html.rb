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

    def handle_ref(node)
      if node.attributes['item']
        pattern, frag = node.attributes['item'].split('#', 2)
        item = @items[pattern]
        if item.nil?
          raise "Cannot find an item matching #{pattern} to link to"
        end
        path = frag ? item.path + '#' + frag : item.path
        tags = [{ name: 'a', attributes: { href: path } }]

        out << 'the '
        output_start_tags(tags)
        if frag
          # FIXME: find section name dynamically
          out << 'relevant section'
          out << ' in the '
        end
        out << item[:title]
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

        output_start_tags(tags)
        handle_children(node)
        output_end_tags(tags)
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
