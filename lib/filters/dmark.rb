# frozen_string_literal: true

class CachingDMarkParser
  class << self
    def parse(content)
      @cache ||= {}
      @cache[content] ||= DMark::Parser.new(content).parse
    end
  end
end

module GenericDMarkFilter
  def run(content, _params = {})
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
