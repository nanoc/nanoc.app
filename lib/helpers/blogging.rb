# encoding: utf-8

module Nanoc3::Helpers

  module Blogging

    def articles
      @items.find { |i| i.identifier == '/blog/' }.children.map { |c| c.children }.flatten
    end

  end

end
