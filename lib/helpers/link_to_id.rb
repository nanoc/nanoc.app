module NanocSite
  module LinkToId
    def link_to_id(id)
      item = @items[id]
      link_to(item[:short_title] || item[:title], item)
    end

    def title_of_id(id)
      item = @items[id]
      item[:short_title] || item[:title]
    end
  end
end
