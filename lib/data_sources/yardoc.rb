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
      slug    = filter.name.to_s.downcase.gsub(/^a-z0-9/, '')
      summary = filter.meths.detect { |m| m.name == :run }.docstring.summary
      identifiers = filter['nanoc_identifiers']

      items << Nanoc::Item.new(
        '-',
        {
          :name        => filter.name,
          :full_name   => filter.path,
          :summary     => summary,
          :identifiers => identifiers
        },
        "/filters/#{slug}")
    end

    # TODO Add helpers

    items
  end

end
