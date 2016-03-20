require 'd-mark'

class NanocWsCommonTranslator < DMark::Translator
  def to_id(string)
    string.downcase.gsub(/\W+/, '-').gsub(/^-|-$/, '')
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

  def nodes_for_item(item)
    if item.identifier.ext == 'dmark'
      DMark::Parser.new(item.raw_content).parse
    else
      nil
    end
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
end
