# encoding: utf-8

class YARDDataSource < Nanoc3::DataSource

  identifier :yard

  def up
    require 'yard'
    YARD::Registry.load!('yardoc')
  end

  def items
    items = []

    # Add filters
    YARD::Registry.at('Nanoc::Filters').children.each do |filter|
      slug        = filter.name.to_s.downcase.gsub(/[^a-z0-9]+/, '-')
      method      = filter.meths.detect { |m| m.name == :run }
      identifiers = filter['nanoc_identifiers']
      examples = method.tags('example').map { |e| { :title => e.name, :code => e.text } }

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

    # Add helpers
    YARD::Registry.at('Nanoc::Helpers').children.each do |helper|
      slug    = helper.name.to_s.downcase.gsub(/^a-z0-9/, '')

      items << Nanoc::Item.new(
        '-',
        {
          :type        => 'helper',
          :name        => helper.name,
          :full_name   => helper.path,
          :summary     => helper.docstring.summary,
          :description => helper.docstring
        },
        "/helpers/#{slug}")
    end

    items
  end

end
