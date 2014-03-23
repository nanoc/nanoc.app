class Nanoc::ItemView
  # used in lib/nanoc/capturing/helper.rb:66
  def item
    resolve
  end

  # used in lib/nanoc/sass/filter.rb:33
  def content
    resolve.content
  end
end

class Nanoc::ItemRepViewForFiltering
  # Used in lib/nanoc/linking/helper.rb:136
  def paths
    # FIXME this is incorrect
    { last: resolve.path }
  end

  # Used in lib/nanoc/xml_sitemap/helper.rb:65
  def paths_without_snapshot
    # FIXME this is incorrect (used in xml sitemap)
    paths.values.compact
  end

  # Used in lib/nanoc/filtering/helper.rb:38
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
# TODO reject identifiers that end with a slash

# IDEA catch all errors, wrap it in an error with an item reference, and rethrow
