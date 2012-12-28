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
          :type        => 'filter',
          :name        => filter.name,
          :full_name   => filter.path,
          :summary     => summary,
          :identifiers => identifiers
        },
        "/filters/#{slug}")
    end

    # TODO Add helpers
    YARD::Registry.at('Nanoc::Helpers').children.each do |helper|
      slug    = helper.name.to_s.downcase.gsub(/^a-z0-9/, '')
      summary = helper.docstring.summary

      items << Nanoc::Item.new(
        '-',
        {
          :type        => 'helper',
          :name        => helper.name,
          :full_name   => helper.path,
          :summary     => summary
        },
        "/helpers/#{slug}")
    end

    items
  end

end
