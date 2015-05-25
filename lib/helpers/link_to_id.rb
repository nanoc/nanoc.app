module NanocSite

  # Provides functionality for creating links to items, given their identifier.
  module LinkToId

    def link_to_id(id)
      item = @items[id]

      html_classes = []
      unless item[:up_to_date_with_nanoc_4]
        html_classes << 'wip'
      end

      link_to(item[:short_title] || item[:title], item, class: html_classes.join(' '))
    end

  end

end
