module NanocSite

  # Provides functionality for creating links to items, given their identifier.
  module LinkToId

    def link_to_id(id)
      item = @items.glob(id).first
      link_to(item[:title], item)
    end

  end

end
