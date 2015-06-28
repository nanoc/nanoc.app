module NanocSite
  module LinkToId
    def link_to_id(id)
      item = @items[id]

      link_to(item[:short_title] || item[:title], item)
    end
  end
end
