require 'dmark'

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  class NanocWsHTMLTranslator < DMark::Translator
    def initialize(tree, items)
      super(tree)
      @items = items
    end

    def handle(node)
      case node
      when DMark::Nodes::RootNode
        handle_children(node)
      when DMark::Nodes::TextNode
        out << node.text
      when DMark::Nodes::ElementNode
        tags = tags_for(node)

        output_start_tags(tags)
        handle_children(node)
        output_end_tags(tags)
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
            out << value
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

    def tags_for(node)
      # returns e.g. [{name: 'pre', attributes: {}}]

      case node.name
      when 'listing'
        [
          { name: 'pre', attributes: {} },
          { name: 'code', attributes: {} },
        ]
      when 'emph'
        [{ name: 'em', attributes: {} }]
      when 'firstterm', 'identifier', 'glob', 'filename', 'class', 'command', 'prompt', 'productname'
        [{ name: 'span', attributes: { class: node.name } }]
      when 'p', 'dl', 'dt', 'dd', 'code', 'kbd', 'h1', 'h2', 'h3', 'ul', 'li'
        [{ name: node.name, attributes: {} }]
      when 'note', 'tip', 'caution'
        [
          { name: 'div', attributes: { class: "admonition-wrapper #{node.name}" } },
          { name: 'div', attributes: { class: 'admonition' } },
        ]
      when 'ref'
        attributes = node.attributes.split(',').map { |piece| piece.split('=') }
        if attributes.any? { |a| a[0] == 'item' }
          pattern = attributes.first { |a| a[0] == 'item' }.last
          path = @items[pattern].path
          [{ name: 'a', attributes: { href: path } }]
        elsif attributes.any? { |a| a[0] == 'url' }
          url = attributes.first { |a| a[0] == 'url' }.last
          [{ name: 'a', attributes: { href: url } }]
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
