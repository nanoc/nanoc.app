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
      if node.children.size != 1 || !node.children.first.is_a?(DMark::Nodes::TextNode)
        raise 'Expected img node to have one text child node'
      else
        src = node.children.first.text
        tags = [{ name: 'img', attributes: { src: src } }]
        output_start_tags(tags)
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
      when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname', 'see', 'log-create', 'log-update', 'uri', 'attribute'
        [{ name: 'span', attributes: attributes.merge(class: node.name) }]
      when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'li', 'figure'
        is_legacy = node.attributes['legacy']
        [{ name: node.name, attributes: attributes.merge(is_legacy ? { class: 'legacy' } : {}) }]
      when 'note', 'tip', 'caution'
        [
          { name: 'div', attributes: attributes.merge(class: "admonition-wrapper #{node.name}") },
          { name: 'div', attributes: attributes.merge(class: 'admonition') },
        ]
      when 'ref'
        if node.attributes['item']
          pattern = node.attributes['item']
          path = @items[pattern].path
          [{ name: 'a', attributes: attributes.merge(href: path) }]
        elsif node.attributes['url']
          url = node.attributes['url']
          [{ name: 'a', attributes: attributes.merge(href: url) }]
        elsif node.attributes['frag']
          frag = node.attributes['frag']
          [{ name: 'a', attributes: attributes.merge(href: "##{frag}") }]
        else
          raise "Cannot translate ref #{node.inspect}"
        end
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
