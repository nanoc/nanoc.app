class Nanoc::Item
  def [](key)
    attributes[key]
  end
end

class Nanoc::ItemView
  def item
    resolve
  end

  def content
    resolve.content
  end
end

class Nanoc::ItemRepViewForFiltering
  def paths
    # FIXME this is incorrect
    { last: resolve.path }
  end

  def compiled?
    resolve.compiled?
  end

  def paths_without_snapshot
    # FIXME this is incorrect (used in xml sitemap)
    paths.values.compact
  end

  def assigns
    {
      item: @item,
      layout: @layout,
      items: @items,
      config: @config,
      site: @site,
    }
  end
end

# TODO (related) let layout '/foo.*' work
# TODO klass.new(@item_rep.assigns) -> just @assigns in filtering helper

# IDEA catch all errors, wrap it in an error with an item reference, and rethrow
