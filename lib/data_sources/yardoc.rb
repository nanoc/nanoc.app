# encoding: utf-8

class YARDDataSource < Nanoc3::DataSource

  identifier :yard

  def up
    require 'yard'
    YARD::Registry.load!('yardoc')
  end

  def items
    items = []

    add_filters_to(items)
    add_helpers_to(items)

    items
  end

  protected

  def add_filters_to(items)
    YARD::Registry.at('Nanoc::Filters').children.each do |filter|
      slug          = filter.name.to_s.downcase.gsub(/[^a-z0-9]+/, '-')
      method        = filter.meths.detect { |m| m.name == :run }
      identifiers   = filter['nanoc_identifiers']
      examples      = method.tags('example').map { |e| { :title => e.name, :code => e.text } }
      is_deprecated = !method.tags('deprecated').empty?

      unless is_deprecated
        items << Nanoc::Item.new(
          '-',
          {
            :type        => 'filter',
            :name        => filter.name,
            :full_name   => filter.path,
            :summary     => method.docstring.summary,
            :description => method.docstring,
            :identifiers => identifiers,
            :examples    => examples
          },
          "/filters/#{slug}")
      end
    end
  end

  def add_helpers_to(items)
    YARD::Registry.at('Nanoc::Helpers').children.each do |helper|
      slug    = helper.name.to_s.downcase.gsub(/^a-z0-9/, '')

      items << Nanoc::Item.new(
        '-',
        {
          :type        => 'helper',
          :name        => helper.name,
          :full_name   => helper.path,
          :summary     => helper.docstring.summary,
          :functions   => helper.meths(:visibility => :public, :included => false).map do |m|
            signature = "#{m.name}(#{m.parameters.map { |n,v| n }.join(", ")})"
            if m.tag(:return) && !m.tag(:return).types.empty?
              signature << " &rarr; #{m.tag(:return).types.first}"
            end
            {
              :name        => m.name,
              :summary     => m.docstring.summary,
              :examples    => m.tags('example').map { |e| { :title => e.name, :code => e.text } },
              :signature   => signature
            }
          end
        },
        "/helpers/#{slug}")
    end
  end

end
