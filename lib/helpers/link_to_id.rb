module Nanoc3::Helpers

  # Provides functionality for creating links to items, given their identifier.
  module LinkToId

    def link_to_id(id)
      item = @items[id]
      link_to(item[:title], item)
    end

  end

end
