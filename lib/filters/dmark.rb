module GenericDMarkFilter
  def run(content, params = {})
    nodes = DMark::Parser.new(content).parse
    context = { items: @items, item: @item, nodes: nodes, binding: binding }
    translator_class.translate(nodes, context)
  rescue => e
    case e
    when DMark::Parser::ParserError
      line = content.lines[e.line_nr]

      lines = [
        e.message,
        "",
        line,
        "\e[31m" + ' ' * e.col_nr + '↑' + "\e[0m",
      ]

      fancy_msg = lines.map { |l| "\e[34m[D*Mark]\e[0m #{l.strip}\n" }.join('')
      raise "D*Mark parser error\n" + fancy_msg
    else
      raise e
    end
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
