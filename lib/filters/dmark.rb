module GenericDMarkFilter
  def run(content, params = {})
    nodes = DMark::Parser.new(content).parse
    context = { items: @items, item: @item, nodes: nodes, binding: binding }
    translator_class.translate(nodes, context)
  rescue => e
    handle_error(e, content)
  end

  def translator_class
    raise NotImplementedError
  end
end

Class.new(Nanoc::Filter) do
  identifier :dmark2html

  include GenericDMarkFilter

  def translator_class
    NanocWsHTMLTranslator
  end
end

Class.new(Nanoc::Filter) do
  identifier :dmark2latex

  include GenericDMarkFilter

  def translator_class
    NanocWsLaTeXTranslator
  end
end
