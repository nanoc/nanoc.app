# frozen_string_literal: true

require 'nokogiri'

Class.new(Nanoc::Filter) do
  identifiers :add_ids_to_headers

  def run(content, _arguments = {})
    defined_ids = Set.new

    doc = Nokogiri::HTML.fragment(content)
    doc.css('h1, h2, h3, h4, h5, h6').each do |header|
      id = header.content.downcase.gsub(/\W+/, '-').gsub(/^-|-$/, '')
      id << '-' while defined_ids.include?(id)
      header['id'] = id
    end
    doc.to_s
  end
end
