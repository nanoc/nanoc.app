class CachingDMarkParser
  class << self
    extend Nanoc::Int::Memoization

    def parse(content)
      DMark::Parser.new(content).parse
    end
    memoize :parse
  end
end

module GenericDMarkFilter
  def run(content, params = {})
    nodes = CachingDMarkParser.parse(content)
    context = { items: @items, item: @item, config: @config, nodes: nodes }
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
